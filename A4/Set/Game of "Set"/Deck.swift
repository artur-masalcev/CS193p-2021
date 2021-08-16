//
//  Deck.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-13.
//

import SwiftUI

/// Represents undealt cards for the game of Set, where all cards are face down
struct Deck: View {
    private var cards: [SetGame.Card]
    private var namespace: Namespace.ID
    private var onTapGesture: () -> ()
    
    init(cards: [SetGame.Card], namespace: Namespace.ID, onTapGesture: @escaping () -> ()) {
        self.cards = cards
        self.namespace = namespace
        self.onTapGesture = onTapGesture
    }
    
    /// Dependently on the id of the card in the deck generates a unique offset to make a sloppy pile of card effect
    /// - Parameter card: game card
    /// - Returns: 'CGFloat' value of offset for the given card
    private func getCardOffset(card: SetGame.Card) -> CGFloat {
        return CGFloat(card.id / DrawingConstants.cardOffsetCoefficient)
    }
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: false)
                    .frame(width: DrawingConstants.cardWidth, height: DrawingConstants.cardHeight)
                    .onTapGesture(perform: onTapGesture)
                    .offset(x: getCardOffset(card: card), y: 0)
                    .matchedGeometryEffect(id: card.id, in: namespace)
            }
        }
    }
    
    //MARK: -Constants
    
    private struct DrawingConstants {
        static var cardOffsetCoefficient: Int = 10
        static var cardHeight: CGFloat = 100
        static var cardWidth: CGFloat = cardHeight * aspectRatio
        static var aspectRatio: CGFloat = 2/3
    }
}
