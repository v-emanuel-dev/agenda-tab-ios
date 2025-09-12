//
//  Agenda_TABApp.swift
//  Agenda TAB
//
//  Created by Victor on 12/09/25.
//

import SwiftUI
import CoreData

@main
struct Agenda_TABApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
