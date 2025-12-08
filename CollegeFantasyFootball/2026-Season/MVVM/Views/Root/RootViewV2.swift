import SwiftUI

struct RootViewV2: View {
    @Environment(SessionManager.self) private var sessionManager
    
    var body: some View {
        if sessionManager.session != nil {
            HomeViewV2(vm: HomeViewModelV2(session: sessionManager.session!))
        } else {
            SignInViewV2(vm: SignInViewV2.ViewModel())
        }
    }
}

#Preview {
    NavigationStack {
        RootViewV2()
    }
}
