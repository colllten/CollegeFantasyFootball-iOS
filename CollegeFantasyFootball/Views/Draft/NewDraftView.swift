//
//  NewDraftView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 8/11/25.
//

import SwiftUI

struct NewDraftView: View {
    @State private var selectedTab: DraftTab = .draft
    @StateObject var vm: NewDraftViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(vm.draftPicks) { draftPick in
                    if let player = draftPick.player {
                        Text("R\(draftPick.round) P\(draftPick.pick): \(player.fullName)")
                    } else {
                        Text("R\(draftPick.round) P\(draftPick.pick): has not drafted")
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .task {
            await vm.loadData()
        }
        .onDisappear {
            Task {
                await vm.unsubscribeToRealtime()
            }
        }
    }
    
//    private var liveDraftPickView: some View {
//        ScrollViewReader { proxy in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 12) {
//                    ForEach(vm.draftPicks, id: \.pick) { pick in
//                        DraftPickView(players: vm.players, pick: pick)
//                            .id(pick.pick)
//                    }
//                }
//                .padding(.horizontal, 16)
//                .opacity(vm.draftPicks.isEmpty ? 0 : 1)
//            }
//            .frame(height: 170)
//            .background(Color(.systemBackground))
//            .onChange(of: vm.draftPicks) { _, _ in
//                vm.scrollToNextPick(proxy: proxy)
//            }
//        }
//    }
    
    enum DraftTab: Hashable {
        case roster
        case draft
        case draftBoard
    }
}
//
//#Preview {
//    NewDraftView()
//}
