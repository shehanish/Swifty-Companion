//
//  LoginView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import SwiftUI

struct LoginView: View {
    @State private var login: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
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
            Button(action: LogIn) {
                Label("Continue with 42 Intra", systemImage: "arrow.right")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, -100)
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 200)
        .background(Color.purple.opacity(0.10))
        .ignoresSafeArea()
    }
        
        
}
    
    // MARK: - Methods
    
    private func LogIn() {
        // TODO: Implement sign in logic with 42 OAuth
        print("Log In tapped")
    }
    

#Preview {
    LoginView()
}
