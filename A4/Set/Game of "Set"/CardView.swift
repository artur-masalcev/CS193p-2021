//
//  CardView.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-02.
//

import SwiftUI

/// Represents a card from the Set game as well as its' state during the game
struct CardView: View {
    typealias Card = SetGame.Card
    private var card: Card
    private var isFaceUp: Bool
    
    init(card: Card, isFaceUp: Bool = true) {
        self.card = card
        self.isFaceUp = isFaceUp
    }
    
    var body: some View {
        if isFaceUp {
            ZStack {
                background
                card.content
                    .padding(DrawingConstants.cardContentPadding)
            }
            .shakeEffect(shakes: card.isMatched == false ? 3 : 0)
        } else {
            ZStack {
                background
            }
        }
    }
    
    @ViewBuilder
    /// Returns "View" which represents the background of the CardView depending on the state of the 'card'
    private var background: some View {
        if !isFaceUp {
            let deckText = Text("SET").foregroundColor(.white).font(.largeTitle).rotationEffect(Angle(degrees: 30))
            
            RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
                .fill().foregroundColor(.orange)
                .overlay(deckText)
            
            RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
                .strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
        } else {
            let background = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            
            if card.isHighlighted {
                background.fill().foregroundColor(.white)
                background.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
                .foregroundColor(.blue)
            }
            else if card.isMatched == true {
                background.fill().foregroundColor(.white)
                background.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
                    .foregroundColor(.green)
            }
            else if card.isMatched == false {
                background.fill().foregroundColor(.white)
                background.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
                    .foregroundColor(.red)
                    .rotationEffect(Angle.degrees(360))
                    .animation(.linear(duration: 1))
            }
            else if card.isSelected {
                background.fill().foregroundColor(.white)
                background.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
                    .foregroundColor(.orange)
            }
            else if !card.isSelected {
                background.fill().foregroundColor(.white)
                background.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
                .foregroundColor(.black)
            }
        }
    }
    
    //MARK: -Constants
    
    private struct DrawingConstants {
        static let cardBorderWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 15
        static let selectedCardBorderWidth: CGFloat = 6
        static let cardContentPadding: CGFloat = 5
    }
}
