//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    /// A store for all playable themes in the game
    @StateObject var themeStore = ThemeStore(name: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeStoreView().environmentObject(themeStore)
        }
    }
}
