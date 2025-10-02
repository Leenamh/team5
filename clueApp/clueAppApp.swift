import SwiftUI

@main
struct clueAppApp: App {
    @StateObject var optionsVM = OptionsViewModel()  // ✅ shared instance

    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(optionsVM) // ✅ inject to all pages
        }
    }
}
