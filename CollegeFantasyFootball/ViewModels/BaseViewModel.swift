//
//  BaseViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import Foundation

@MainActor
class BaseViewModel: ObservableObject {
    let supabase = SupabaseManager.shared.client
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    let previewPrinting = true
    
    func previewPrint(_ message: String) {
        if previewPrinting {
            print(message)
        }
    }
}
