import SwiftUI
import FactoryKit

@main
struct CollegeFantasyFootballApp: App {
    @State private var sessionManager = Container.shared.sessionManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    Color.backgroundMain
                        .ignoresSafeArea()
                    
                    RootViewV2()
                        .environment(sessionManager)
                }
            }
        }
    }
}
