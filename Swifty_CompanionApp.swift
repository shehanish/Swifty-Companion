//
//  Swifty_CompanionApp.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 20.03.26.
//

import SwiftUI

@main
struct Swifty_CompanionApp: App {
    // Create ONE AuthManager for the whole app
    @StateObject var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                // Pass the manager into ContentView
                ContentView(authManager: authManager)
                    .preferredColorScheme(.light)
            } else {
                // Pass the manager into LoginView
                LoginView(authManager: authManager)
                    .preferredColorScheme(.light)
            }
        }
    }
}
