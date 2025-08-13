//
//  LoadingModifier.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import Foundation
import SwiftUI
//import SwiftUICore

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
            ZStack {
                content // always keep the content present
                    .disabled(isLoading) // optional: prevent interaction
                    .blur(radius: isLoading ? 2 : 0) // optional visual cue
                
                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    CustomProgressView()
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
