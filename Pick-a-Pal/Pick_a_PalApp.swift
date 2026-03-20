//
//  Pick_a_PalApp.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI
import SwiftData

@main
struct Pick_a_PalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PalModel.self)
        }
    }
}
