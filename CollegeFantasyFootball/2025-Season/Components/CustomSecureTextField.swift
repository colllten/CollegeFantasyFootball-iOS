//
//  CustomSecureTextField.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import SwiftUI

struct SecureCustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .frame(height: 55)
            .padding(.horizontal)
            .background(Color(.systemGray4))
            .cornerRadius(10)
            .contentShape(Rectangle()) // Expands tappable area
    }
}

#Preview {
    SecureCustomTextField(placeholder: "", text: .constant(""))
}
