//
//  ContentView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 20.03.26.
//

import SwiftUI


let navyBlue = Color(red: 0.04, green: 0.15, blue: 0.33)
let backgroundGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.98, green: 0.92, blue: 0.99),
        Color(red: 0.95, green: 0.97, blue: 1.0),
        Color(red: 0.97, green: 0.99, blue: 0.96)    
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing)

struct ContentView: View {
    
    @ObservedObject var authManager: AuthManager
    @State private var searchText: String = ""

    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: - CUSTOM HEADER
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome, \(authManager.loggedInUser?.login ?? "Student")")
                            .font(.title2)
                            .foregroundColor(navyBlue.opacity(3))
                            
                    }
                    
                    Spacer()
                    
                    // Profile Image
                    AsyncImage(url: URL(string: authManager.loggedInUser?.image?.link ?? "")) { image in
                                            image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        // Shows this gray icon while the real image is downloading
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(navyBlue.opacity(0.5))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.leading, 110)
                .padding(.trailing, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Title
                Text("FIND YOUR PEERS AT 42!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(navyBlue.opacity(0.7))
                
                // Glassmorphism Search Widget
                VStack(spacing: 20) {
                    // Search Field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(navyBlue)
                        
                        TextField("Enter student login", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    
                    // Search Button
                    Button(action: searchStudent) {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(navyBlue)
                            .cornerRadius(10)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: searchText.isEmpty)
                
                Spacer()
                Spacer()
            }
        }
    }
    
    private func searchStudent() {
        print("Searching for: \(searchText)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authManager: AuthManager())
    }
}
