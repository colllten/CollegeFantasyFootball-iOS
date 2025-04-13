//
//  CustomNavigationLink.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/12/25.
//

import SwiftUI

struct CustomNavigationLink<Destination: View>: View {
    var title: String
    var destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            Text(title)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .font(.headline)
                .fontWeight(.semibold)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
