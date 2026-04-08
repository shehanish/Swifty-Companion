//
//  AuthenticationManager.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import Foundation
import AuthenticationServices

class AuthManager {
    
    let clientID = APISecrets.shared.uid
    
    let redirectURI = "swiftycompanion://callback"
    let callbackScheme = "swiftycompanion"
    
    var webAuthSession: ASWebAuthenticationSession?
    
    func startLogin() {
        let urlString =  "https://api.intra.42.fr/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=code"
        
        guard let authorizeURL = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = ASWebAuthenticationSession(url: authorizeURL, callbackURLScheme: callbackScheme) { callbackURL, error in
            
            if let error = error {
                print("Error or user canceled: \(error.localizedDescription)")
                return
            }
            guard let successURL = callbackURL else { return }
            
            // C. Print the result!
            print("🎉 SUCCESS! 42 sent us back to: \(successURL)")
        }
        let contextProvider = ContextProvider()
        session.presentationContextProvider = contextProvider
        session.start()
    }
            
}

// MARK: - Helper Class
class ContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }
}


