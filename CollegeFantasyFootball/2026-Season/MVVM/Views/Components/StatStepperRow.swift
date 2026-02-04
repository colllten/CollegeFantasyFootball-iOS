//
//  StatStepperRow.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 1/19/26.
//

import SwiftUI

struct StatStepperRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        Stepper(value: $value, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                Text(
                    value.formatted(.number.precision(.fractionLength(1)))
                )
                .monospacedDigit()
                .frame(width: 40, alignment: .trailing)
            }
        }
    }
}
