//
//  LoginView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import SwiftUI

let darkBlue = Color(red: 0.04, green: 0.15, blue: 0.33)
struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showAuthErrorAlert = false
    
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
                            authViewModel.startLogin()
                        }) {
                            Label("Continue with 42 Intra", systemImage: "arrow.right")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(darkBlue)
                                .cornerRadius(10)
                        }
            .alert("Sign In Failed", isPresented: Binding(
                get: { showAuthErrorAlert },
                set: { newValue in
                    showAuthErrorAlert = newValue
                    if !newValue {
                        authViewModel.authErrorMessage = nil
                    }
                }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.authErrorMessage ?? "The app could not complete sign in.")
            }
            
            Spacer()
        }
        .padding(30)
        .background(Color.purple.opacity(0.10))
        .ignoresSafeArea()
        .onChange(of: authViewModel.authErrorMessage) { _, newValue in
            showAuthErrorAlert = newValue != nil
        }
    }
    
    // MARK: - Methods
    private func LogIn() {
        authViewModel.startLogin()
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
}
