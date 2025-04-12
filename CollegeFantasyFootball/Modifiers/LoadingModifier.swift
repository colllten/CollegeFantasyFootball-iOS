//
//  LoadingModifier.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation
import SwiftUI
import SwiftUICore

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                CustomProgressView()
            } else {
                content
            }
        }
    }
}


struct CustomProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .padding()
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}


extension View {
    func withLoading(_ isLoading: Bool) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}
