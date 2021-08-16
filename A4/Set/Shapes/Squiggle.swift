//
//  Squiggle.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-05.
//

import SwiftUI

/// Squiggle shape from the Set game
struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        let width = min(rect.width, rect.height)
        let height = width / 2
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX + width / 2, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.midX - width / 2, y: rect.midY),
                      control1: CGPoint(x: rect.midX + width / 10, y: rect.midY - height*2),
                      control2: CGPoint(x: rect.midX - width / 10, y: rect.midY + height/4))
        
        path.move(to: CGPoint(x: rect.midX - width / 2, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.midX + width / 2, y: rect.midY),
                      control1: CGPoint(x: rect.midX - width / 10, y: rect.midY + height),
                      control2: CGPoint(x: rect.midX + width / 10, y: rect.midY - height))
        
        return path
    }
    
    private struct DrawingConstants {
        static let opacity: Double = 0.3
    }
}
