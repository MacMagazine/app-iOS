//
//  MacMagazineApp.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 09/10/2025.
//

import StorageLibrary
import SwiftUI
import SwiftData

@main
struct MacMagazineApp: App {
    @ObservedObject var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(viewModel.storage.sharedModelContainer)
                .environmentObject(viewModel)
                .environmentObject(viewModel.settingsViewModel)
                .preferredColorScheme(viewModel.colorSchema)
        }
        .environment(\.theme, viewModel.theme)
    }
}
