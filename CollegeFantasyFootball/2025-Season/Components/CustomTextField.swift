//
//  CustomTextField.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/7/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .autocorrectionDisabled()
            .frame(height: 55)
            .padding(.horizontal)
            .background(Color(.systemGray4))
            .cornerRadius(10)
            .contentShape(Rectangle())
    }
}

#Preview {
    CustomTextField(placeholder: "", text: .constant(""))
}
