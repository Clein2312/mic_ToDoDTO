//
//  ToDo_VaporApp.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 30.04.25.
//

import SwiftUI
import SwiftData

@main
struct ToDo_VaporApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ToDoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ToDoItemViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
