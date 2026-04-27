//
//  User.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import Foundation

struct IntraUser: Codable {
    let id: Int
    let login: String
    let displayname: String
    let email: String
    let phone: String?           // Added for mandatory
    let location: String?        // Added for mandatory
    let wallet: Int
    let correction_point: Int
    let image: IntraImage?
    let cursus_users: [CursusUser]
    let projects_users: [ProjectUser] // Added for Projects
    
    let titles: [IntraTitle]?
}

struct IntraTitle: Codable {
    let name: String
}
struct IntraImage: Codable {
    let link: String?
}

struct CursusUser: Codable {
    let level: Double
    let cursus: Cursus
    let skills: [Skill]
}

struct Cursus: Codable {
    let id: Int
    let name: String
}

struct Skill: Codable, Identifiable {
    let id: Int
    let name: String
    let level: Double
}

struct ProjectUser: Codable, Identifiable {
    let id: Int
    let status: String
    let final_mark: Int?
    let `validated?`: Bool? // Backticks needed because the API sends a question mark!
    let project: ProjectDetails
}

struct ProjectDetails: Codable {
    let id: Int
    let name: String
}
