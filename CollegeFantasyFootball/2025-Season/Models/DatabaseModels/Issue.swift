//
//  Issue.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/22/25.
//

import Foundation

struct Issue: Codable {
    let id: UUID
    let userId: UUID
    let issueText: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case issueText = "issue_text"
    }
}
