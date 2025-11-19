import SwiftUI

struct PreDraftView: View {
    @ObservedObject var vm: PreDraftViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            draftDateCountdown
            
            Spacer()
            
            VStack(spacing: 16) {
                settingsNavLink
                startDraftButton
            }
            .padding(.horizontal)
            .disabled(!vm.userIsLeagueOwner)
            .opacity(vm.userIsLeagueOwner ? 1 : 0.5)
        }
        .padding()
        .navigationDestination(isPresented: $vm.showDraftView) {
            DraftView(vm: DraftViewModel(fantasyLeague: vm.fantasyLeague))
//            NewDraftView(vm: NewDraftViewModel(fantasyLeague: vm.fantasyLeague))
                .navigationBarBackButtonHidden(true)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    InviteUserView(vm: InviteUserViewModel(fantasyLeague: vm.fantasyLeague))
                } label: {
                    Image(systemName: "person.fill.badge.plus")
                        .accessibilityLabel("Invite User")
                }
            }
        }
        .task {
            await vm.subscribeToRealtimeDraftStatus()
        }
        .onDisappear {
            Task {
                await vm.unsubscribeToRealtime()
            }
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
        .background(
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var draftDateCountdown: some View {
        VStack(spacing: 10) {
            VStack(spacing: 4) {
                Text(vm.fantasyLeague.draftDate.dayOfWeek())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
                
                Text(vm.fantasyLeague.draftDate.monthAndDay())
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
                
                Text(vm.fantasyLeague.draftDate.timeString())
                    .font(.title3)
                    .fontWeight(.medium)
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [Color.accentColor.opacity(0.15), Color.accentColor.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                    )
                    .shadow(color: .accentColor.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal)
            
            Text("Mark your calendar for the draft")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .italic()
                .padding(.top, 8)
            
            Button {
                vm.addDraftToCalendar(date: vm.fantasyLeague.draftDate)
            } label: {
                Label("Add to Calendar", systemImage: "calendar.badge.plus")
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(8)
            }
            .accessibilityLabel("Add draft date to calendar")
            .buttonStyle(.borderedProminent)
            
            DraftCountdownView(draftDate: vm.fantasyLeague.draftDate)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }

    
    private var settingsNavLink: some View {
        NavigationLink {
            FantasyLeagueSettingsView(vm: FantasyLeagueSettingsViewModel(fantasyLeague: vm.fantasyLeague))
        } label: {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(vm.userIsLeagueOwner ? Color.blue : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Open fantasy league settings")
        }
        .disabled(!vm.userIsLeagueOwner)
    }
    
    private var startDraftButton: some View {
        Button {
            Task {
                await vm.startDraftPressed()
            }
        } label: {
            Text("Start Draft")
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Start the fantasy draft")
        }
        .buttonStyle(.borderedProminent)
        .tint(vm.userIsLeagueOwner ? .red : .gray)
        .disabled(!vm.userIsLeagueOwner)
    }
}
