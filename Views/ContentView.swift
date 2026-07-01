//
//  ContentView.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 20.03.26.
//

import SwiftUI

let navyBlue = Color(red: 0.04, green: 0.15, blue: 0.33)
let skyBlue = Color(red: 0.85, green: 0.93, blue: 1.0)
let mintTint = Color(red: 0.88, green: 0.97, blue: 0.92)
let backgroundGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.98, green: 0.92, blue: 0.99),
        Color(red: 0.95, green: 0.97, blue: 1.0),
        Color(red: 0.97, green: 0.99, blue: 0.96)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing)

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                Circle()
                    .fill(skyBlue.opacity(0.45))
                    .frame(width: 280, height: 280)
                    .blur(radius: 40)
                    .offset(x: 140, y: -220)

                Circle()
                    .fill(mintTint.opacity(0.45))
                    .frame(width: 240, height: 240)
                    .blur(radius: 40)
                    .offset(x: -150, y: 220)

                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack(spacing: 24) {
                                header
                                heroCard
                                searchCard
                            }
                            .frame(maxWidth: 620)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: proxy.size.height, alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, -14)
                    }
                }
            }
            .navigationDestination(isPresented: $authViewModel.shouldNavigateToPeerDetails) {
                PeerDetailsView(authViewModel: authViewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .alert("User Not Found", isPresented: $authViewModel.shouldShowSearchError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("No 42 student exists with the login '\(searchText)'.")
        }
    }

    private func searchStudent() {
        isSearchFocused = false
        authViewModel.searchForPeer(login: searchText)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome back")
                    .font(.caption.uppercaseSmallCaps())
                    .tracking(1.2)
                    .foregroundColor(navyBlue.opacity(0.55))

                Text(authViewModel.loggedInUser?.login ?? "Student")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(navyBlue)
            }

            Spacer()

            Menu {
                Button(role: .destructive, action: { authViewModel.logout() }) {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } label: {
                AsyncImage(url: URL(string: authViewModel.loggedInUser?.image?.link ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(navyBlue.opacity(0.45))
                }
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.55), lineWidth: 1)
        )
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Find your next peer")
                        .font(.title2.weight(.bold))
                        .foregroundColor(navyBlue)

                    Text("Jump straight to a student's profile and keep track of their level, wallet, projects, and skills.")
                        .font(.subheadline)
                        .foregroundColor(navyBlue.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(navyBlue.opacity(0.7))
                    .padding(12)
                    .background(Color.white.opacity(0.8), in: Circle())
            }

            HStack(spacing: 10) {
                StatusChip(text: "Profiles")
                StatusChip(text: "Projects")
                StatusChip(text: "Skills")
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.92), Color.white.opacity(0.68)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.65), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
    }

    private var searchCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search a student")
                .font(.headline.weight(.semibold))
                .foregroundColor(navyBlue)

            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(navyBlue.opacity(0.75))

                TextField("Enter student login", text: $searchText)
                    .focused($isSearchFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit(searchStudent)

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            )

            Button(action: searchStudent) {
                HStack(spacing: 10) {
                    if authViewModel.isSearching {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.right.circle.fill")
                    }

                        Text(authViewModel.isSearching ? "Searching..." : "Search")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(.white)
                .background(navyBlue, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
                    .disabled(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || authViewModel.isSearching)
            .opacity(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.65 : 1)

            Text("Tip: use a 42 login, not a display name.")
                .font(.caption)
                .foregroundColor(navyBlue.opacity(0.55))
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.55), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 10)
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        ContentView(authViewModel: authViewModel)
    }
}

private struct StatusChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(navyBlue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(navyBlue.opacity(0.08), in: Capsule())
    }
}
