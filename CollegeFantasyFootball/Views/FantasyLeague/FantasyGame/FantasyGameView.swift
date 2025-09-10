import SwiftUI

struct FantasyGameView: View {
    @StateObject var vm: FantasyGameViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    ForEach(lineupRows, id: \.label) { row in
                        LineupRowView(row: row, vm: vm)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $vm.showAddPlayerToLineupSheet) {
            if let pos = vm.selectedPosition,
               let lineup = vm.selectedLineup {
                AddPlayerToLineupSheet(
                    vm: AddPlayerToLineupSheetViewModel(
                        fantasyLeague: vm.fantasyGame.fantasyLeague,
                        openPosition: pos,
                        fantasyLineup: lineup.fantasyLineup
                    )
                )
            }
        }
        .navigationTitle("Matchup")
        .task { await vm.loadData() }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
    }
    
    private var header: some View {
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
    
    fileprivate struct LineupRow {
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
    
    private func pointsString(for player: Player?) -> String {
        guard let player else { return "-" }
        
        var gameStats = vm.homeLineupStats.first { $0.player.id == player.id }
        if gameStats == nil {
            gameStats = vm.awayLineupStats.first { $0.player.id == player.id }
        }
        
        if let pts = gameStats?.fantasyPoints(league: vm.fantasyGame.fantasyLeague) {
            return String(format: "%.1f", pts)
        }
        return "—"
    }
    
    private func scoreString(isHome: Bool) -> String {
        let lineup = isHome ? vm.homeLineupStats : vm.awayLineupStats
        let total = lineup.reduce(0.0) { $0 + $1.fantasyPoints(league: vm.fantasyGame.fantasyLeague) }
        return String(format: "%.1f", total)
    }
}

// MARK: - Subviews

private struct LineupRowView: View {
    let row: FantasyGameView.LineupRow
    @ObservedObject var vm: FantasyGameViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            playerCell(for: row.awayPlayer, lineup: vm.awayLineup, isHome: false)
            
            Text(row.label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(minWidth: 30)
            
            playerCell(for: row.homePlayer, lineup: vm.homeLineup, isHome: true)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(height: 75)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func playerCell(for player: Player?, lineup: FantasyLineupDto, isHome: Bool) -> some View {
        if let player {
            HStack(spacing: 6) {
                if isHome {
                    Text(formattedPoints(for: player))
                        .font(.subheadline)
                        .monospacedDigit()
                        .frame(minWidth: 25, alignment: isHome ? .leading : .trailing)
                    Spacer()
                }
                
                PlayerGameView(player: player,
                               url: vm.fetchPlayerImageUrl(playerId: player.id),
                               isHome: isHome)
                if !isHome {
                    Spacer()
                    Text(formattedPoints(for: player))
                        .font(.subheadline)
                        .monospacedDigit()
                        .frame(minWidth: 25, alignment: isHome ? .leading : .trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: isHome ? .trailing : .leading)
        } else {
            if lineup.user.id == AuthManager.shared.currentUserId! {
                Text("Add to lineup")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onTapGesture {
                        vm.selectedPosition = row.label
                        vm.selectedLineup = lineup
                        vm.showAddPlayerToLineupSheet = true
                    }
                    .onChange(of: vm.showAddPlayerToLineupSheet) { _, new in
                        if !new { Task { await vm.loadData() } }
                    }
            } else {
                Text("Empty")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    private func formattedPoints(for player: Player?) -> String {
        vm.pointsString(for: player)
    }
}

// MARK: - PlayerGameView

private struct PlayerGameView: View {
    let player: Player
    let url: URL?
    let isHome: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            if !isHome {
                playerHeadshot
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(player.firstName.first!). \(player.lastName)")
                    .font(.caption)
                
                Text("\(idSchoolPairs[player.teamId]!)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if isHome {
                playerHeadshot
            }
        }
        .padding(.vertical, 6)
    }
    
    private var playerHeadshot: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                avatarPlaceholder
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            case .failure:
                avatarPlaceholder
            @unknown default:
                avatarPlaceholder
            }
        }
    }
    
    private func initials(from player: Player) -> String {
        let firstInitial = player.firstName.first.map(String.init) ?? ""
        let lastInitial = player.lastName.first.map(String.init) ?? ""
        return firstInitial + lastInitial
    }
    
    private var avatarPlaceholder: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 44, height: 44)
            Text(initials(from: player))
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.gray)
        }
    }
}
