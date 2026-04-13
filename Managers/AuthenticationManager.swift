//
//  AuthenticationManager.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import Foundation
import AuthenticationServices
import SwiftUI

class AuthManager: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    // MARK: - Properties
    let clientID = APISecrets.shared.uid
    let clientSecret = APISecrets.shared.secret
    let redirectURI = "swiftycompanion://callback"
    let callbackScheme = "swiftycompanion"
    
    var webAuthSession: ASWebAuthenticationSession?
    
    @Published var isAuthenticated = false
    @Published var loggedInUser: IntraUser?
    @Published var searchedUser: IntraUser? // This will hold the peer we search for!
    var accessToken: String? // We need to save the token here!
    
    // MARK: - Phase 1 & 2: Get the Code
    func startLogin() {
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=code"
        
        guard let authorizeURL = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        self.webAuthSession = ASWebAuthenticationSession(url: authorizeURL, callbackURLScheme: callbackScheme) { callbackURL, error in
            
            if let error = error {
                print("Error or user canceled: \(error.localizedDescription)")
                return
            }
            guard let successURL = callbackURL else { return }
            print("SUCCESS! 42 sent us back to: \(successURL)")
            
            // Extract the temporary "code" from the URL
            guard let components = URLComponents(url: successURL, resolvingAgainstBaseURL: false),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                print("Could not find the code in the URL!")
                return
            }
            
            print("Got the code: \(code)")
            
            // Move to Phase 3!
            self.exchangeCodeForToken(code: code)
        }
        
        // We set `self` as the helper, so it never disappears
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.prefersEphemeralWebBrowserSession = true
        self.webAuthSession?.start()
    }
    
    // MARK: - Phase 3: Trade Code for Token
    private func exchangeCodeForToken(code: String) {
        print("Exchanging code for token...")
        
        let tokenURL = URL(string: "https://api.intra.42.fr/oauth/token")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        
        // We are packing our UID, Secret, and Code into the body of the request
        let bodyString = "grant_type=authorization_code&client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)&redirect_uri=\(redirectURI)"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received from token request.")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("====== RAW TOKEN JSON ======")
                print(jsonString)
                print("============================")
            }
            
           
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                // Save it for later searches!
                self.accessToken = tokenResponse.access_token
                self.fetchMyProfile(token: tokenResponse.access_token)
                
                print("Token Decoded Successfully!")
                
                // Note: Make sure your TokenModel.swift uses "access_token" exactly like this!
                self.fetchMyProfile(token: tokenResponse.access_token)
                
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted:", context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key.stringValue)' not found:", context.debugDescription)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
            } catch {
                print("Unknown decoding error: ", error)
            }
            
        }.resume()
    }
    
    // MARK: - Phase 4: Fetch User Profile
    private func fetchMyProfile(token: String) {
        print("Fetching profile with token...")
        
        let profileURL = URL(string: "https://api.intra.42.fr/v2/me")!
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("====== RAW PROFILE JSON ======")
                // This prints the first 500 characters so it doesn't flood your console
                print(String(jsonString.prefix(500)) + "...\n==============================")
            }
            
            do {
                let user = try JSONDecoder().decode(IntraUser.self, from: data)
                
                // Update the UI on the Main Thread (SwiftUI requires this)
                DispatchQueue.main.async {
                    self.loggedInUser = user
                    self.isAuthenticated = true
                    print("🎉 Fully logged in as \(user.login)!")
                }
            } catch {
                print(" Failed to decode user profile: \(error)")
            }
            
        }.resume()
    }
    
    // MARK: - Phase 5: Log Out
    func logout() {
        DispatchQueue.main.async {
            // 1. Delete the user profile from memory
            self.loggedInUser = nil
            // 2. Flip the boolean back to false (This instantly kicks them back to the Login screen!)
            self.isAuthenticated = false
        }
        print("User signed out successfully.")
    }
    
    // MARK: - Helper Window Function
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }
    
    // MARK: - Phase 6: Search For Peer
    func searchForPeer(login: String, completion: @escaping (Bool) -> Void) {
        guard let token = self.accessToken else {
            completion(false)
            return
        }
        
        // Clean up the text (remove spaces, make it lowercase)
        let cleanLogin = login.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 🚨 THE NEW ENDPOINT: We put their name right in the URL!
        let searchURL = URL(string: "https://api.intra.42.fr/v2/users/\(cleanLogin)")!
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if the server said "404 Not Found"
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    print("❌ User not found!")
                    completion(false) // Tell the UI it failed
                }
                return
            }
            
            do {
                // We reuse your exact same IntraUser model!
                let user = try JSONDecoder().decode(IntraUser.self, from: data)
                
                DispatchQueue.main.async {
                    self.searchedUser = user
                    print("✅ Found peer: \(user.login)")
                    completion(true) // Tell the UI it succeeded!
                }
            } catch {
                print("❌ Failed to decode peer: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
}


