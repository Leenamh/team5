//
//  clueAppApp.swift
//  clueApp
//
//  Created by leena almusharraf on 29/09/2025.
//

import SwiftUI

@main
struct clueAppApp: App {
    @StateObject var optionsVM = OptionsViewModel()  // ✅ نسخة وحدة مشتركة

    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(optionsVM)  // ✅ تمرير للـ Home وجميع الصفحات اللي تحتها
        }
    }
}
