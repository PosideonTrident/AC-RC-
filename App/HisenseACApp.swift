import SwiftUI

@main
struct HisenseACApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HisenseService())
        }
    }
}
