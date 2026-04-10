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
    
    // MARK: - Helper Window Function
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }
}
