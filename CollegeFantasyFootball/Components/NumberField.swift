//
//  NumberField.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/19/25.
//

import SwiftUI

struct NumberField: View {
    @Binding var value: Double
    
    // Initializer to simplify usage
    init(_ value: Binding<Double>) {
        self._value = value
    }
    
    var body: some View {
        TextField(
            "\(value)",                    // Placeholder or initial display
            value: $value,                 // Bind to the float value
            format: .number                // Use number format for cleaner input/output
        )
        .keyboardType(.decimalPad)         // Set keyboard to decimal pad for numeric input
    }
}
