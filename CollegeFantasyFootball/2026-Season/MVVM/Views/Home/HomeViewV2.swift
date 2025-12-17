import SwiftUI
import Supabase

enum Route: Hashable {
    case createLeague
}

struct HomeViewV2: View {
    @State var vm: HomeViewModelV2
    @Environment(\.navigationPath) private var path
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
        .safeAreaInset(edge: .top) {
            profileHeaderButton
        }
        .safeAreaInset(edge: .bottom) {
            createLeagueFooterButton
                .padding()
        }
        .navigationDestination(for: Route.self, destination: { route in
            switch (route) {
            case .createLeague:
                // TODO: Add form view
                Text("Create League Form")
            }
        })
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
    
    private var createLeagueFooterButton: some View {
        Button {
            path?.wrappedValue.append(Route.createLeague)
        } label: {
            Text("Create Fantasy League")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.40, green: 0.65, blue: 0.45))
                .foregroundStyle(.offWhite)
                .fontWeight(.medium)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var profileHeaderButton: some View {
        HStack {
            Spacer()
            Button {
                //
            } label: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    NavigationStack(path: $path) {
        ZStack {
            Color.backgroundMain.ignoresSafeArea()
            HomeViewV2(vm: HomeViewModelV2(session: .homePreviewSession))
                .environment(\.navigationPath, $path)
        }
    }
}
