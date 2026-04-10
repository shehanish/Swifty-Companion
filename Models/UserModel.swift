//
//  User.swift
//  Swifty Companion
//
//  Created by Shehani Hansika on 23.03.26.
//

import Foundation

struct IntraUser: Codable {
    let login: String
    let image: IntraImage?
}

struct IntraImage: Codable {
    let link: String?
}
