import SwiftUI

struct FantasyGameView: View {
    @StateObject var vm: FantasyGameViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header.padding(.horizontal)
                
                VStack(spacing: 10) {
                    ForEach(lineupRows, id: \.label) { row in
                        HStack(alignment: .center) {
                            HStack(spacing: 6) {
                                Text(pointsString(for: row.awayPlayer))
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .frame(minWidth: 28, alignment: .trailing)
                                Spacer()
                                Text(name(for: row.awayPlayer))
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(row.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 44)
                            
                            HStack(spacing: 6) {
                                Text(name(for: row.homePlayer))
                                    .font(.subheadline)
                                Spacer()
                                Text(pointsString(for: row.homePlayer))
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .frame(minWidth: 28, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(height: 75)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Matchup")
        .task { await vm.loadData() }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
    }
    
    private var header: some View {
        // Scores: away left, home right
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.fantasyGame.awayUser?.username ?? "Away")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.secondary)
                    Text(scoreString(isHome: false))
                        .font(.system(size: 36, weight: .bold))
                        .monospacedDigit()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(vm.fantasyGame.homeUser?.username ?? "Home")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.secondary)
                    Text(scoreString(isHome: true))
                        .font(.system(size: 36, weight: .bold))
                        .monospacedDigit()
                }
            }
            Text("Week \(vm.fantasyGame.week)\(vm.fantasyGame.isPlayoff ? " • Playoff" : "")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private struct LineupRow {
        let label: String
        let homePlayer: Player?
        let awayPlayer: Player?
    }
    
    private var lineupRows: [LineupRow] {
        [
            .init(label: "QB", homePlayer: vm.homeLineup.qb, awayPlayer: vm.awayLineup.qb),
            .init(label: "RB", homePlayer: vm.homeLineup.rb, awayPlayer: vm.awayLineup.rb),
            .init(label: "TE", homePlayer: vm.homeLineup.te, awayPlayer: vm.awayLineup.te),
            .init(label: "WR1", homePlayer: vm.homeLineup.wr1, awayPlayer: vm.awayLineup.wr1),
            .init(label: "WR2", homePlayer: vm.homeLineup.wr2, awayPlayer: vm.awayLineup.wr2),
            .init(label: "FLEX", homePlayer: vm.homeLineup.flex, awayPlayer: vm.awayLineup.flex),
            .init(label: "PK", homePlayer: vm.homeLineup.pk, awayPlayer: vm.awayLineup.pk),
            .init(label: "P", homePlayer: vm.homeLineup.p, awayPlayer: vm.awayLineup.p)
        ]
    }
    
    private func name(for player: Player?) -> String {
        player?.fullName ?? "—"
    }
    
    private func pointsString(for player: Player?) -> String {
        if player == nil {
            return "-"
        }
        
        var gameStats = vm.homeLineupStats.first { stats in
            stats.player.id == player?.id
        }
        if gameStats == nil {
            gameStats = vm.awayLineupStats.first { stats in
                stats.player.id == player?.id
            }
        }
        
        if let pts = gameStats?.fantasyPoints(league: vm.fantasyGame.fantasyLeague) {
            return String(format: "%.1f", pts)
        } else {
            return "—"
        }

    }
    
    private func scoreString(isHome: Bool) -> String {
        var points = 0.0
        
        let lineup = isHome ? vm.homeLineupStats : vm.awayLineupStats
        for stats in lineup {
            points += stats.fantasyPoints(league: vm.fantasyGame.fantasyLeague)
        }
        
        return String(format: "%.1f", points)
    }
}
