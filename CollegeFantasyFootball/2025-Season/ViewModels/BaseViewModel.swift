//
//  BaseViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import Foundation

@MainActor
public class BaseViewModel: ObservableObject {
    let season = UserDefaults.standard.integer(forKey: "season")
    
    let supabase = SupabaseManager.shared.client
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    private static let previewPrinting = false
    
    public static func previewPrint(_ message: String) {
        if previewPrinting {
            print(message)
        }
    }
}
