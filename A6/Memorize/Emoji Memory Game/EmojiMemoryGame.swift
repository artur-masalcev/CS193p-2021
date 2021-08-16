//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-27.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    /// State of the memory game
    @Published private var model: MemoryGame<String>
    
    /// Theme of the game
    var theme: MemoryGameTheme<String> {
        didSet {
            startNewGame()
        }
    }
    
    init(theme: MemoryGameTheme<String>) {
        self.theme = theme
        model = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { index in
            theme.content[index]
        }
    }

    /// Memory game cards
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    /// Memory game score
    var score: Int {
        model.score
    }

    // MARK: - Intent(s)

    /// Processes user's interaction with a chosen game card
    /// - Parameter card: The chosen card
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    /// Restarts the game
    func startNewGame() {
        model = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { index in
            theme.content[index]
        }
    }
}
