//
//  PeerDetailsView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 11.04.26.
//

import SwiftUI

struct PeerDetailsView: View {
    // Placeholder for the user you will display
    // let user: UserModel
    
    var body: some View {
        ZStack {
            // Reusing the same gradient from your other views
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.92, blue: 0.99),
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.97, green: 0.99, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Peer Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    // You can add the user's profile information here
                    // For example:
                    // Text(user.displayName)
                    // Text(user.login)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PeerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        // You can create a mock user here for the preview
        PeerDetailsView()
    }
}
