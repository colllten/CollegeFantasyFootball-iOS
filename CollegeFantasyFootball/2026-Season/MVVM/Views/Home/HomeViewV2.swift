import FactoryKit
import SwiftUI

struct HomeViewV2: View {
    @State var vm: HomeViewModelV2
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Section {
                    Button("Sign Out") {
                        Task {
                            await vm.signOutButtonTapped()
                        }
                        dismiss()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                profileHeaderButton
            }
            
            ToolbarItem(placement: .bottomBar) {
                createLeagueFooterButton
            }
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
    
    private var createLeagueFooterButton: some View {
        Button("Create League") {
            // TODO
        }
        .font(.title3)
        .buttonStyle(.glassProminent)
        .tint(Color(red: 0.40, green: 0.65, blue: 0.45))
        .foregroundStyle(.offWhite)
    }
    
    private var profileHeaderButton: some View {
        Image(systemName: "person.crop.circle")
            .onTapGesture {
                // TODO
            }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            Color.backgroundMain.ignoresSafeArea()
            HomeViewV2(vm: HomeViewModelV2(session: .homePreviewSession))
        }
    }
}
