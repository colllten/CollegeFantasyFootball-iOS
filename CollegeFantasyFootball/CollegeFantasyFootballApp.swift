import SwiftUI
import FactoryKit

@main
struct CollegeFantasyFootballApp: App {
    @State private var sessionManager = Container.shared.sessionManager()
    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    Color.backgroundMain
                        .ignoresSafeArea()
                    
                    RootViewV2()
                        .environment(sessionManager)
                        .environment(\.navigationPath, $path)
                }
            }
        }
    }
}

private struct NavigationPathKey: EnvironmentKey {
    static let defaultValue: Binding<NavigationPath>? = nil
}

extension EnvironmentValues {
    var navigationPath: Binding<NavigationPath>? {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}
