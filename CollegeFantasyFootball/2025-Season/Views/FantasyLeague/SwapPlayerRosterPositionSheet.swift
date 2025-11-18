//
//  SwapPlayerRosterPositionSheet.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 5/19/25.
//

import SwiftUI

// TODO: Duplicate players when selecting bench players
struct SwapPlayerRosterPositionSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: SwapPlayerRosterPositionSheetViewModel
    
    var body: some View {
        ScrollView {
            PlayerRow(
                player: vm.selectedPlayer,
                position: vm.selectedPlayer?.position ?? "",
                action: { _ in },
                actionText: nil
            )
            .padding(.bottom, 100)
            
            if vm.selectedPlayerPostion == "starting_wr1_id" {
                PlayerRow(
                    player: vm.rosterPlayers.startingWr2,
                    position: "WR2",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "starting_wr2_id",
                                destinationPlayer: vm.rosterPlayers.startingWr2
                            )
                        dismiss()
                    }
                }
            }
            
            if vm.selectedPlayerPostion == "starting_wr2_id" {
                PlayerRow(
                    player: vm.rosterPlayers.startingWr1,
                    position: "WR1",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "starting_wr1_id",
                                destinationPlayer: vm.rosterPlayers.startingWr1
                            )
                        dismiss()
                    }
                }
            }
            
            if vm.selectedPlayer?.id ?? 0 != vm.rosterPlayers.bench1?.id {
                PlayerRow(
                    player: vm.rosterPlayers.bench1,
                    position: "BE",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "bench1_id",
                                destinationPlayer: vm.rosterPlayers.bench1
                            )
                        dismiss()
                    }
                }
            }
            if vm.selectedPlayer?.id ?? 0 != vm.rosterPlayers.bench2?.id {
                PlayerRow(
                    player: vm.rosterPlayers.bench2,
                    position: "BE",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "bench2_id",
                                destinationPlayer: vm.rosterPlayers.bench2
                            )
                        dismiss()
                    }
                }
            }
            if vm.selectedPlayer?.id ?? 0 != vm.rosterPlayers.bench3?.id {
                PlayerRow(
                    player: vm.rosterPlayers.bench3,
                    position: "BE",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "bench3_id",
                                destinationPlayer: vm.rosterPlayers.bench3
                            )
                        dismiss()
                    }
                }
            }
            if vm.selectedPlayer?.id ?? 0 != vm.rosterPlayers.bench4?.id {
                PlayerRow(
                    player: vm.rosterPlayers.bench4,
                    position: "BE",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "bench4_id",
                                destinationPlayer: vm.rosterPlayers.bench4
                            )
                        dismiss()
                    }
                }
            }
            if vm.selectedPlayer?.id ?? 0 != vm.rosterPlayers.bench5?.id {
                PlayerRow(
                    player: vm.rosterPlayers.bench5,
                    position: "BE",
                    action: { _ in },
                    actionText: nil
                )
                .onTapGesture {
                    Task {
                        await vm
                            .trySwapPlayerRosterPositions(
                                sourceRosterPosition: vm.selectedPlayerPostion,
                                sourcePlayer: vm.selectedPlayer,
                                destinationRosterPosition: "bench5_id",
                                destinationPlayer: vm.rosterPlayers.bench5
                            )
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Swap players")
        .navigationBarTitleDisplayMode(.inline)
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
}

#Preview {
    NavigationStack {
        SwapPlayerRosterPositionSheet(
            vm: SwapPlayerRosterPositionSheetViewModel(
                fantasyLeague: FantasyLeague.mock,
                selectedPlayerPosition: "starting_qb_id",
                selectedPlayer: Player(
                    id: 1,
                    season: 2024,
                    firstName: "Colten",
                    lastName: "Glover",
                    height: 68,
                    weight: 150,
                    jersey: 4,
                    position: "QB",
                    teamId: 2483
                ),
                rosterPlayers: RosterPlayers(
                    startingQb: Player(
                        id: 1,
                        season: 2024,
                        firstName: "Colten",
                        lastName: "Glover",
                        height: 68,
                        weight: 150,
                        jersey: 4,
                        position: "QB",
                        teamId: 128
                    ),
                    bench1: Player(
                        id: 1,
                        season: 2024,
                        firstName: "Drew",
                        lastName: "Lock",
                        height: 68,
                        weight: 150,
                        jersey: 4,
                        position: "QB",
                        teamId: 2483
                    ))
            )
        )
    }
}
