//
//  TwoPlayerSetGame.swift
//  Set
//
//  Created by Artur Masalcev on 2021-08-15.
//

import Foundation

/// Adds two player mode support to SetGame
struct TwoPlayerSetGame {
    /// This struct encapsulates a single-player version of "Set" game and adds tools to make it look like two player mode
    private var game: SetGame
    
    var firstPlayerScore = 0
    var secondPlayerScore = 0
    var whichPlayerIsChoosing: Player?
    var cardsOnTheTable: [SetGame.Card] {
        game.cardsOnTheTable
    }
    
    init() {
        game = SetGame()
    }
    
    /// Processes and handles user's interaction with a card on the table. Dependably on player that chooses the set, assigns the score
    /// - Parameter card: the chosen card from the table
    mutating func choose(_ card: SetGame.Card) {
        guard let whichPlayerIsChoosing = self.whichPlayerIsChoosing else {
            return
        }
        
        let oldScoreValue = game.score
        
        game.choose(card)
        
        if oldScoreValue != game.score {
            if whichPlayerIsChoosing == .first {
                firstPlayerScore += game.score - oldScoreValue
            }
            else {
                secondPlayerScore += game.score - oldScoreValue
            }
        }
    }
    
    /// Finds and highlights a set if there are any on the table. If not set is found, automatically draws three cards
    mutating func hint() {
        game.hint()
    }
    
    /// Adds three more cards on the table and removes them from the deck
    mutating func dealThreeMoreCards(by player: Player) {
        let oldScoreValue = game.score
        
        game.dealThreeMoreCards()
        
        if oldScoreValue != game.score {
            if player == .first {
                firstPlayerScore += game.score - oldScoreValue
            }
            else {
                secondPlayerScore += game.score - oldScoreValue
            }
        }
    }
    
    /// Sets the player who claimed that they have found a set
    mutating func setChoosingPlayer(player: Player) {
        whichPlayerIsChoosing = player
    }
    
    enum Player {
        case first, second
    }
}
