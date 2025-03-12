//
//  AKC_SCT_CalculatorApp.swift
//  AKC SCT Calculator
//
//  Created by FRANK GILMER on 3/11/25.
//

import SwiftUI

@main
struct AKC_SCT_CalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
