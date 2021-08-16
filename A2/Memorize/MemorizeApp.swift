//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-18.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
