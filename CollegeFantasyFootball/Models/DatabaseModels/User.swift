//
//  User.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/22/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let username: String
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    static let mock = User(
        id: UUID(),
        username: "someUsername",
        firstName: "First",
        lastName: "Last")
}
