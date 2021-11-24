//
//  GeoSnake2App.swift
//  GeoSnake2
//
//  Created by iosdev on 23.11.2021.
//

import SwiftUI

@main
struct GeoSnake2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
