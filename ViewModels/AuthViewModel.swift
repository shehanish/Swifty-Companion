import Foundation
import AuthenticationServices
import SwiftUI

final class AuthViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    private let clientID = APISecrets.shared.uid
    private let clientSecret = APISecrets.shared.secret
    private let redirectURI = "swiftycompanion://callback"
    private let callbackScheme = "swiftycompanion"
    private let apiClient: APIClient

    var webAuthSession: ASWebAuthenticationSession?

    @Published var isAuthenticated = false
    @Published var loggedInUser: IntraUser?
    @Published var searchedUser: IntraUser?
    @Published var authErrorMessage: String?
    @Published var accessToken: String?
    @Published var isSearching = false
    @Published var shouldNavigateToPeerDetails = false
    @Published var shouldShowSearchError = false

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func startLogin() {
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=code"

        guard let authorizeURL = URL(string: urlString) else {
            authErrorMessage = "Invalid authorization URL."
            return
        }

        webAuthSession = ASWebAuthenticationSession(url: authorizeURL, callbackURLScheme: callbackScheme) { [weak self] callbackURL, error in
            guard let self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.authErrorMessage = error.localizedDescription
                }
                return
            }

            guard let successURL = callbackURL,
                  let components = URLComponents(url: successURL, resolvingAgainstBaseURL: false),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                DispatchQueue.main.async {
                    self.authErrorMessage = "Could not read the authorization code."
                }
                return
            }

            self.exchangeCodeForToken(code: code)
        }

        webAuthSession?.presentationContextProvider = self
        webAuthSession?.prefersEphemeralWebBrowserSession = true
        webAuthSession?.start()
    }

    func logout() {
        DispatchQueue.main.async {
            self.loggedInUser = nil
            self.accessToken = nil
            self.isAuthenticated = false
        }
    }

    func searchForPeer(login: String) {
        guard let token = accessToken else {
            DispatchQueue.main.async {
                self.authErrorMessage = "Missing access token."
                self.shouldShowSearchError = true
            }
            return
        }

        DispatchQueue.main.async {
            self.isSearching = true
            self.shouldShowSearchError = false
            self.shouldNavigateToPeerDetails = false
        }

        apiClient.searchForPeer(login: login, token: token) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.isSearching = false

                switch result {
                case .success(let user):
                    self.searchedUser = user
                    self.shouldNavigateToPeerDetails = true
                case .failure(let error):
                    self.authErrorMessage = error.localizedDescription
                    self.shouldShowSearchError = true
                }
            }
        }
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }

    private func exchangeCodeForToken(code: String) {
        apiClient.exchangeCodeForToken(
            code: code,
            clientID: clientID,
            clientSecret: clientSecret,
            redirectURI: redirectURI
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let tokenResponse):
                DispatchQueue.main.async {
                    self.accessToken = tokenResponse.access_token
                    self.authErrorMessage = nil
                }
                self.fetchMyProfile(token: tokenResponse.access_token)

            case .failure(let error):
                DispatchQueue.main.async {
                    self.authErrorMessage = error.localizedDescription
                }
            }
        }
    }

    private func fetchMyProfile(token: String) {
        apiClient.fetchMyProfile(token: token) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.loggedInUser = user
                    self.isAuthenticated = true
                    self.authErrorMessage = nil
                case .failure(let error):
                    self.authErrorMessage = error.localizedDescription
                }
            }
        }
    }
}