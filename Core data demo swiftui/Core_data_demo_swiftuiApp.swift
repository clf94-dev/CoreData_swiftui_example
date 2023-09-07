//
//  Core_data_demo_swiftuiApp.swift
//  Core data demo swiftui
//
//  Created by Carmen Lucas on 7/9/23.
//

import SwiftUI

@main
struct Core_data_demo_swiftuiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
