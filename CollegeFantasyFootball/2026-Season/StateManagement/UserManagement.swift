//
//  UserManagement.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/10/25.
//

import Foundation

final class UserManagement {
    private enum AuthState {
        case signedIn(User)
        case signedOut
    }
}
