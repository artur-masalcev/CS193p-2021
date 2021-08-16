//
//  CardView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-09.
//

import SwiftUI

/// Shows a state of the emoji memory game card
struct CardView: View {
    init(_ card: MemoryGame<String>.Card){
        self.card = card
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
        static let padding: CGFloat = 5
    }
    
    private let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            if !card.isMatched || card.isFaceUp {
                Text(card.content).font(getEmojiFont(in: geometry.size))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1))
                    .cardify(isFaceUp: card.isFaceUp)
                    .padding(DrawingConstants.padding)
                }
            else {
                Color.clear
            }
        }
    }
    
    private func getEmojiFont(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
}
