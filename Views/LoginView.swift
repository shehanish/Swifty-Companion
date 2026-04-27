//
//  LoginView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import SwiftUI

let darkBlue = Color(red: 0.04, green: 0.15, blue: 0.33)
struct LoginView: View {
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Avatar Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(darkBlue)
            
            VStack(spacing: 8) {
                // Title and Subtitle
                Text("Log in to Continue")
                    .font(.title2)
                    .foregroundColor(darkBlue)
                    .fontWeight(.bold)
                
                Text("Access your 42 profile and explore your stats")
                    .font(.subheadline)
                    .foregroundColor(darkBlue)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 20)
            
            // Login Button
            Button(action: {
                            print("🔵 BUTTON TAPPED!")
                            authManager.startLogin()
                        }) {
                            Label("Continue with 42 Intra", systemImage: "arrow.right")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(darkBlue)
                                .cornerRadius(10)
                        }
            
            Spacer()
        }
        .padding(30)
        .background(Color.purple.opacity(0.10))
        .ignoresSafeArea()
    }
    
    // MARK: - Methods
    private func LogIn() {
        authManager.startLogin()
    }
}

#Preview {
    LoginView(authManager: AuthManager())
}
