//
//  SetApp.swift
//  Set
//
//  Created by Artur Masalcev on 2021-06-30.
//

import SwiftUI

var colorBlindMode = false

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(game: TwoPlayerSetGameViewModel())
        }
    }
}
