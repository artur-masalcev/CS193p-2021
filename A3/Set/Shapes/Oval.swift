//
//  File.swift
//  Set
//
//  Created by Artur Masalcev on 2021-07-08.
//

import SwiftUI

/// Oval shape from the game of Set
struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width / 5
        let arcRadius = height
        var path = Path()
    
        path.addArc(center: CGPoint(x: 0 + arcRadius, y: rect.midY),
                    radius: arcRadius,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 90),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: width - arcRadius, y: rect.midY + height))
        
        path.addArc(center: CGPoint(x: (width - arcRadius), y: rect.midY),
                    radius: arcRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 270),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: arcRadius, y: rect.midY - height))
        
        return path
    }
}
