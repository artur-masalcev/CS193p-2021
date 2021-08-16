//
//  ShakeEffect.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-17.
//

import SwiftUI

/// Makes a shake effect on the change of the 'shakes' field
struct ShakeEffect: GeometryEffect {
    private static let animationSpreadWidth: CGFloat = -10
    private static let animationIntensityCoefficient: CGFloat = 1
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: ShakeEffect.animationSpreadWidth * sin(position * ShakeEffect.animationIntensityCoefficient * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

extension View {
    func shakeEffect(shakes: Int) -> some View {
        modifier(ShakeEffect(shakes: shakes))
    }
}
