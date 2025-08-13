//
//  RosterPlayers.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/15/25.
//

import Foundation

struct RosterPlayers: Codable {
    var startingQb: Player?
    var startingRb: Player?
    var startingWr1: Player?
    var startingWr2: Player?
    var startingTe: Player?
    var startingP: Player?
    var startingPk: Player?
    var bench1: Player?
    var bench2: Player?
    var bench3: Player?
    var bench4: Player?
    var bench5: Player?
    
    static let mock = RosterPlayers()
}
