//
//  CardView.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-02.
//

import SwiftUI

/// Represents current state of the game card
struct CardView: View {
    typealias Card = SetGame.Card
    
    private var card: Card
    private var isForColorBlind: Bool
    
    init(card: Card, isForColorBlind: Bool = false) {
        self.card = card
        self.isForColorBlind = isForColorBlind
    }
    
    var body: some View {
        let background = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            .strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
            .contentShape(RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius))
        
        ZStack {
            Group {
                if card.isHighlighted {
                    background.foregroundColor(.blue)
                }
                else if !card.isSelected {
                    background.foregroundColor(.black)
                }
                else if card.isMatched == true {
                    background.foregroundColor(.green)
                }
                else if card.isMatched == false {
                    background.foregroundColor(.red)
                }
                else if card.isSelected {
                    background.foregroundColor(.orange)
                }
            }
            
            card.content.padding(DrawingConstants.cardContentPadding)
            
            Group {
                if isForColorBlind {
                    cardColorForColorBlind(color: card.color).font(.largeTitle).opacity(0.5)
                }
            }
        }
        
    }
    
    private func cardColorForColorBlind(color: SetGame.Color) -> some View {
        switch color {
        case .first:
            return Text("R")
        case .second:
            return Text("G")
        case .third:
            return Text("P")
        }
    }
    
    private struct DrawingConstants {
        static let cardBorderWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 15
        static let selectedCardBorderWidth: CGFloat = 6
        static let cardContentPadding: CGFloat = 5
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let previewCard = SetGame.Card(number: .two, shape: .third, color: .third, shading: .third, id: 12)
        CardView(card: previewCard)
    }
}
