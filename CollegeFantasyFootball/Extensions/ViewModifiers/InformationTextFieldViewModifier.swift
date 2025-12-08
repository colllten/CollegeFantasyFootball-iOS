//
//  InformationTextFieldViewModifier.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/19/25.
//

import SwiftUI

struct InformationTextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .padding(.horizontal)
//            .background(Color(.systemGray4))
            .background(Color.white.opacity(0.15))
            .cornerRadius(10)
            .contentShape(Rectangle())
    }
}

extension View {
    func defaultTextFieldStyle() -> some View {
        modifier(InformationTextFieldViewModifier())
    }
}
