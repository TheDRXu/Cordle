//
//  WordleApp.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import SwiftUI

@main
struct WordleApp: App {
    @StateObject var dm = WordleDataModel()
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)
        }
    }
}
