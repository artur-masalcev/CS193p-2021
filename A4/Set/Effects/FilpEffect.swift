//
//  FlipEffect.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-18.
//

import SwiftUI

/// Makes a card like flip effect for the set game card. During the 3D rotation both the back and front of the card are showed
struct FlipEffect: AnimatableModifier {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            if rotation > 90 {
                let deckText = Text("SET").foregroundColor(.white).font(.largeTitle).rotationEffect(Angle(degrees: DrawingConstants.textTilt))
                
                RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
                    .fill().foregroundColor(.orange)
                    .overlay(deckText)
                
                RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
                    .strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cardBorderWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 15
        static let textTilt: Double = 30 //in degrees
    }
}

extension View {
    func flipEffect(isFaceUp: Bool) -> some View {
        self.modifier(FlipEffect(isFaceUp: isFaceUp))
    }
}
