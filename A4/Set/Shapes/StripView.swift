import SwiftUI

/// Makes a stripped fill in the view
struct StripView<T>: View where T: Shape {
    let numberOfStrips: Int = 15
    let lineWidth: CGFloat = 2
    let borderLineWidth: CGFloat = 1
    let color: Color
    let shape: T
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfStrips) { number in
                Color.white
                color.frame(width: lineWidth)
                if number == numberOfStrips - 1 {
                    Color.white
                }
            }
            
        }.mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderLineWidth))
    }
}
