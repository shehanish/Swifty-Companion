//
//  LoginView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import SwiftUI

struct LoginView: View {
    @State private var authManager = AuthManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
            
            // Title and Subtitle
            Text("Log in to Continue")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Access your 42 profile and explore your stats")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
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
                                .background(Color.black) // Changed to blue so it matches your picture!
                                .cornerRadius(10)
                        }
            
            Spacer()
                .padding()
            
        }
        .padding()
        .padding(.top, 200)
        .background(Color.purple.opacity(0.10))
        .ignoresSafeArea()
    }
    
    // MARK: - Methods
    private func LogIn() {
        authManager.startLogin()
    }
}

#Preview {
    LoginView()
}
