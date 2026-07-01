//
//  Swifty_CompanionApp.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 20.03.26.
//

import SwiftUI

@main
struct Swifty_CompanionApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView(authViewModel: authViewModel)
                    .preferredColorScheme(.light)
            } else {
                LoginView(authViewModel: authViewModel)
                    .preferredColorScheme(.light)
            }
        }
    }
}
