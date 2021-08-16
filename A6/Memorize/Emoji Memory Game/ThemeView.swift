//
//  ThemeView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-15.
//

import SwiftUI

func themeView(theme: MemoryGameTheme<String>) -> some View {
    let spacingValueInThemeView: CGFloat = 5
    let lineLimitInThemeView: Int = 1
    
    return VStack(alignment: .leading, spacing: spacingValueInThemeView) {
        HStack {
            Text(theme.name)
                .foregroundColor(Color.black).font(.title3).bold()
            Circle().foregroundColor(Color(theme.color)).fixedSize()
        }
        Text("\(theme.numberOfPairsOfCards) pairs from \(String(theme.content))").lineLimit(lineLimitInThemeView)
    }
}
