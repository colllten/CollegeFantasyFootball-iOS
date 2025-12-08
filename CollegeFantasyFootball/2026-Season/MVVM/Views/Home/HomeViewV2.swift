import SwiftUI
import Supabase

struct HomeViewV2: View {
    @State var vm: HomeViewModelV2
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("SESSION: \(vm.session)")
            
            Button("Sign Out") {
                Task {
                    await vm.signOutButtonTapped()
                }
                dismiss()
            }
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
}

//#Preview {
//    HomeViewV2()
//}
