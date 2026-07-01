import Foundation

final class APIClient {
	static let shared = APIClient()

	private init() {}

	func exchangeCodeForToken(
		code: String,
		clientID: String,
		clientSecret: String,
		redirectURI: String,
		completion: @escaping (Result<TokenResponse, Error>) -> Void
	) {
		let tokenURL = URL(string: "https://api.intra.42.fr/oauth/token")!
		var request = URLRequest(url: tokenURL)
		request.httpMethod = "POST"

		var components = URLComponents()
		components.queryItems = [
			URLQueryItem(name: "grant_type", value: "authorization_code"),
			URLQueryItem(name: "client_id", value: clientID),
			URLQueryItem(name: "client_secret", value: clientSecret),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "redirect_uri", value: redirectURI)
		]

		request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
		request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")

		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(APIClientError.noData))
				return
			}

			if let httpResponse = response as? HTTPURLResponse,
			   !(200...299).contains(httpResponse.statusCode) {
				if let tokenError = try? JSONDecoder().decode(TokenErrorResponse.self, from: data) {
					completion(.failure(APIClientError.serverMessage(tokenError.error_description ?? tokenError.error ?? "Unknown token error")))
				} else {
					completion(.failure(APIClientError.badStatus(httpResponse.statusCode)))
				}
				return
			}

			do {
				let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
				completion(.success(tokenResponse))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func fetchMyProfile(token: String, completion: @escaping (Result<IntraUser, Error>) -> Void) {
		let profileURL = URL(string: "https://api.intra.42.fr/v2/me")!
		var request = URLRequest(url: profileURL)
		request.httpMethod = "GET"
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(APIClientError.noData))
				return
			}

			do {
				let user = try JSONDecoder().decode(IntraUser.self, from: data)
				completion(.success(user))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func searchForPeer(login: String, token: String, completion: @escaping (Result<IntraUser, Error>) -> Void) {
		let cleanLogin = login.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let searchURL = URL(string: "https://api.intra.42.fr/v2/users/\(cleanLogin)")!
		var request = URLRequest(url: searchURL)
		request.httpMethod = "GET"
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data,
				  let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200 else {
				completion(.failure(APIClientError.notFound))
				return
			}

			do {
				let user = try JSONDecoder().decode(IntraUser.self, from: data)
				completion(.success(user))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}

private struct TokenErrorResponse: Codable {
	let error: String?
	let error_description: String?
}

enum APIClientError: LocalizedError {
	case noData
	case badStatus(Int)
	case serverMessage(String)
	case notFound

	var errorDescription: String? {
		switch self {
		case .noData:
			return "No response data received."
		case .badStatus(let code):
			return "Request failed with status code \(code)."
		case .serverMessage(let message):
			return message
		case .notFound:
			return "User not found."
		}
	}
}

