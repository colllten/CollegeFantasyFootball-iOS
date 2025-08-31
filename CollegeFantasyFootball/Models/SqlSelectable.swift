//
//  SqlSelectable.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/31/25.
//

import Foundation

protocol SqlSelectable {
    static func selectAll(keys: String...) -> String
}
