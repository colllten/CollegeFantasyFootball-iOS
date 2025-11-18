//
//  UIApplicationExtensions.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/13/25.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
