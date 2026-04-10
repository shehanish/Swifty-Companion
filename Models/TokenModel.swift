//
//  Token.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//
 import Foundation

struct TokenResponse: Codable {
    let access_token: String
    let created_at: Int?
    let expires_in: Int?
    let refresh_token: String?
}



