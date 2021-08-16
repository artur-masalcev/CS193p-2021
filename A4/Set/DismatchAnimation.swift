//
//  DismatchAnimation.swift
//  Set
//
//  Created by Артур Масальцев on 2021-07-17.
//

import SwiftUI

struct DismatchAnimation: ViewModifier {
    private let animationSpeed: Double = 2
    private let repeatCount = 5
    private var isMatched: Bool?
    
    init(isMatched: Bool?) {
        self.isMatched = isMatched
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle.degrees(isMatched == false ? 30 : 0))
            .animation(isMatched == false ? .easeOut.repeatCount(repeatCount).speed(animationSpeed) : .default)
            .rotationEffect(Angle.degrees(isMatched == false ? -30 : 0))
            .animation(isMatched == false ? .easeOut.repeatCount(repeatCount).speed(animationSpeed).delay(animationSpeed) : .default)
    }
}

extension View {
    func dismatchAnimation(isMatched: Bool?) -> some View {
        modifier(DismatchAnimation(isMatched: isMatched))
    }
}
