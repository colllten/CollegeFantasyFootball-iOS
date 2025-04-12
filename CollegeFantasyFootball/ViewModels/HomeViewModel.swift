//
//  HomeViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation

class HomeViewModel: BaseViewModel {
    
    public func signOut() {
        UserDefaults.standard.set("", forKey: "userId")
    }
}
