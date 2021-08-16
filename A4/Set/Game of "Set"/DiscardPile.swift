//
//  DiscardPile.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-14.
//

import SwiftUI

/// Pile of card that contains card of the Set game that already been matched
struct DiscardPile: View {
    private var cards: [SetGame.Card]
    private var namespace: Namespace.ID
    
    init(cards: [SetGame.Card], namespace: Namespace.ID) {
        self.cards = cards
        self.namespace = namespace
    }
    
    /// Dependently on the id of the card in the deck generates a unique offset to make a sloppy pile of card effect
    /// - Parameter card: game card
    /// - Returns: 'CGFloat' value of offset for the given card
    private func getCardOffset(card: SetGame.Card) -> CGFloat {
        return CGFloat(card.id / DrawingConstants.cardOffsetCoefficient)
    }
    
    @State var unstackedCards = [SetGame.Card]() // Cards that have only been showed to be put in the discard pile
    
    /// Checks whether the card have only appeared to be placed in discard pile
    /// - Parameter card: game card
    /// - Returns: 'true' if card is have only appeared to be placed in discard pile. 'false' if card is already in discard pile
    private func isunstacked(_ card: SetGame.Card) -> Bool {
        unstackedCards.contains(where: {card.id == $0.id})
    }
    
    /// Mark the card to be placed in the discard pile
    /// - Parameter card: game card
    private func stack(_ card: SetGame.Card) {
        unstackedCards.append(card)
    }
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card)
                    .frame(width: DrawingConstants.cardWidth, height: DrawingConstants.cardHeight)
                    .offset(x: getCardOffset(card: card), y: 0)
                    .rotation3DEffect(Angle.degrees(isunstacked(card) ? DrawingConstants.cardRotationDegrees : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(.easeIn.delay(DrawingConstants.animationDelay))
                    .onAppear() {
                        stack(card)
                    }
                    .matchedGeometryEffect(id: card.id, in: namespace)
            }
        }.transition(.scale)
    }
    
    private struct DrawingConstants {
        static var cardOffsetCoefficient: Int = 10
        static var cardRotationDegrees: Double = 180
        static var cardHeight: CGFloat = 100
        static var cardWidth: CGFloat = cardHeight * aspectRatio
        static var aspectRatio: CGFloat = 2/3
        static var animationDelay: Double = 0.5
    }
}
