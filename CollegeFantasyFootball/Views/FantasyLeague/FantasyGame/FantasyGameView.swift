import SwiftUI

struct FantasyGameView: View {
    @StateObject var vm: FantasyGameViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Scores: away left, home right
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(vm.fantasyGame.awayUser?.username ?? "Away")
                                .font(.title)
                                .bold()
                                .foregroundStyle(.secondary)
                            Text(scoreString(vm.fantasyGame.awayScore))
                                .font(.system(size: 36, weight: .bold))
                                .monospacedDigit()
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(vm.fantasyGame.homeUser?.username ?? "Home")
                                .font(.title)
                                .bold()
                                .foregroundStyle(.secondary)
                            Text(scoreString(vm.fantasyGame.homeScore))
                                .font(.system(size: 36, weight: .bold))
                                .monospacedDigit()
                        }
                    }
                    Text("Week \(vm.fantasyGame.week)\(vm.fantasyGame.isPlayoff ? " • Playoff" : "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Lineups: home points near middle on left of name; away points near middle on right of name
                VStack(spacing: 10) {
                    ForEach(lineupRows, id: \.label) { row in
                        HStack(alignment: .center) {
                            // Home column (aligned to center)
                            HStack(spacing: 6) {
                                Text(pointsString(for: row.away))
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .frame(minWidth: 28, alignment: .trailing)
                                Spacer()
                                Text(name(for: row.away))
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text(row.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 44)
                            
                            // Away column (aligned to center)
                            HStack(spacing: 6) {
                                Text(name(for: row.home))
                                    .font(.subheadline)
                                Spacer()
                                Text(pointsString(for: row.home))
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .frame(minWidth: 28, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private struct LineupRow {
        let label: String
        let home: Player?
        let away: Player?
    }
    
    private var lineupRows: [LineupRow] {
        [
            .init(label: "QB", home: vm.homeLineup.qb, away: vm.awayLineup.qb),
            .init(label: "RB", home: vm.homeLineup.rb, away: vm.awayLineup.rb),
            .init(label: "TE", home: vm.homeLineup.te, away: vm.awayLineup.te),
            .init(label: "WR1", home: vm.homeLineup.wr1, away: vm.awayLineup.wr1),
            .init(label: "WR2", home: vm.homeLineup.wr2, away: vm.awayLineup.wr2),
            .init(label: "FLEX", home: vm.homeLineup.flex, away: vm.awayLineup.flex),
            .init(label: "PK", home: vm.homeLineup.pk, away: vm.awayLineup.pk),
            .init(label: "P", home: vm.homeLineup.p, away: vm.awayLineup.p)
        ]
    }
    
    private func name(for player: Player?) -> String {
        player?.fullName ?? "—"
    }
    
    private func pointsString(for player: Player?) -> String {
        // Placeholder until points are calculated
        player == nil ? "—" : "0.0"
    }
    
    private func scoreString(_ value: Float?) -> String {
        guard let v = value else { return "—" }
        return String(format: "%.1f", v)
    }
}
