//
//  Diamond.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-04.
//

import SwiftUI

/// Diamond shape from the game of Set
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = min(rect.height, rect.width)
        let height = width / 3
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY - height))
        path.addLine(to: CGPoint(x: rect.midX + width / 2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + height))
        path.addLine(to: CGPoint(x: rect.midX - width / 2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - height))
        
        return path
    }
    
    private struct DrawingConstants {
        static let opacity: Double = 0.3
    }
}
