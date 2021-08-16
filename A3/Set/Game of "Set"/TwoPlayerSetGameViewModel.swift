//
//  UISetGame.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-03.
//

import SwiftUI

/// SwiftUI implementation for the game of Set
class TwoPlayerSetGameViewModel: ObservableObject {
    typealias Card = SetGame.Card
    typealias Player = TwoPlayerSetGame.Player
    
    @Published private var model = TwoPlayerSetGame()
    
    /// Cards that are visible to the player
    var cardsOnTheTable: [Card] {
        model.cardsOnTheTable
    }
    
    var firstPlayerScore: Int {
        model.firstPlayerScore
    }
    
    var secondPlayerScore: Int {
        model.secondPlayerScore
    }
    
    var whichPlayerIsChoosing: Player? {
        model.whichPlayerIsChoosing
    }
    
    //MARK: -Intents
    
    /// Processes and handles user's interaction with a card on the table
    /// - Parameter card: the chosen card from the table
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    /// Selects the player who claimed to name a set
    func setChoosingPlayer(_ player: Player) {
        model.setChoosingPlayer(player: player)
    }
    
    /// Finds and highlights a set if there are any on the table. If not set is found, automatically draws three cards
    func hint() {
        model.hint()
    }
    
    /// Starts a  new game with a random ordered set of cards
    func newGame() {
        model = TwoPlayerSetGame()
    }
    
    /// Adds three more cards on the table and removes them from the deck
    func dealThreeMoreCards(by player: Player) {
        model.dealThreeMoreCards(by: player)
    }
}

// Adds ability for Set game 'Card' to return it's content in SwiftUI 'some View'
extension SetGame.Card {
    /// Converts the shape value of 'card' to SwiftUI 'some View' value
    /// - Parameter card: the given card
    /// - Returns: SwiftUI 'some View' for the shape of the given card
    @ViewBuilder
    private func getShape(card:SetGame.Card) -> some View {
        let borderWidth: CGFloat = 1
        
        switch card.shape {
        case .first:
            switch card.shading {
            case .first:
                Diamond()
            case .second:
                StripView(color: card.getUIColor(), shape: Diamond())
            case .third:
                Diamond().stroke(lineWidth: borderWidth)
            }
        case .third:
            switch card.shading {
            case .first:
                Oval()
            case .second:
                StripView(color: card.getUIColor(), shape: Oval())
            case .third:
                Oval().stroke(lineWidth: borderWidth)
            }
        case .second:
            switch card.shading {
            case .first:
                Squiggle()
            case .second:
                StripView(color: card.getUIColor(), shape: Squiggle())
            case .third:
                Squiggle().stroke(lineWidth: borderWidth)
            }
        }
    }
    
    /// Converts the colour value of the 'self' to SwiftUI Color value
    /// - Returns: SwiftUI Color value for the colour of 'self'
    private func getUIColor() -> Color {
        switch self.color {
        case .first:
            return .red
        case .second:
            return .green
        case .third:
            return .purple
        }
    }
    
    /// The content of the card in SwiftUI 'some View'
    @ViewBuilder
    var content: some View {
        let shape = getShape(card: self)
        
        switch self.number {
        case .one:
            VStack(alignment: .center){
                shape
            }.foregroundColor(self.getUIColor())
        case .two:
            VStack(alignment: .center){
                shape
                shape
            }.foregroundColor(self.getUIColor())
        case .three:
            VStack(alignment: .center){
                shape
                shape
                shape
            }.foregroundColor(self.getUIColor())
        }
    }
}
