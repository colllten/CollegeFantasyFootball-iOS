//
//  CompletionAnimation.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 4/20/25.
//

import SwiftUI

struct CompletionAnimation: View {
    @State private var animateMask = false
       
       var body: some View {
           ZStack {
               RoundedRectangle(cornerRadius: 10)
                   .frame(width: 400, height: 400)
                   .foregroundStyle(.gray)
//                   .blur(radius: 3)
//                   .opacity(0.95)
                   .padding()
               
               // Background checkmark (white)
               Image(systemName: "checkmark")
                   .resizable()
                   .frame(width: 250, height: 250)
                   .foregroundStyle(.white)
               
               // Animated foreground checkmark (black) with mask
               Image(systemName: "checkmark")
                   .resizable()
                   .frame(width: 250, height: 250)
                   .foregroundStyle(.black)
                   .mask(
                       GeometryReader { geo in
                           Rectangle()
                               .frame(width: animateMask ? geo.size.width : 0)
                               .animation(.easeOut(duration: 1), value: animateMask)
                               .frame(maxWidth: .infinity, alignment: .leading)
                       }
                   )
           }
           .onAppear {
               animateMask = true
           }
       }
}

#Preview {
    CompletionAnimation()
}
