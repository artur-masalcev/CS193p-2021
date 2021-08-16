//
//  DefaultEmojiThemes.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-07.
//

import Foundation

/// Default themes for memory game, where card content is represented with emoji. Used as a starter theme kit for new players
struct DefaultEmojiThemes {
    typealias Theme = MemoryGameTheme<String>
    typealias Color = MemoryGameTheme<String>.RGBAColor
    
    /// Returns array of default emoji themes
    static var all: [Theme] {
        var themes = [Theme]()
        
        themes.append(DefaultEmojiThemes.various)
        themes.append(DefaultEmojiThemes.food)
        themes.append(DefaultEmojiThemes.animals)
        themes.append(DefaultEmojiThemes.drinks)
        themes.append(DefaultEmojiThemes.red)
        themes.append(DefaultEmojiThemes.summer)
        
        return themes
    }
    
    // MARK: - Themes
    
    /// A theme for emoji memory game
    static let various = Theme(name: "Various",
                        content: ["🥳", "🥰", "🤯", "🦁","🥶","🤥","🐠","🙄","👾","👻",
                                  "👑","🎓","🐜","🐘","🐳","🦏","🎄","🍄","🌷","🔥"],
                        numberOfPairsOfCards: 5,
                        color: Color(red: 57, green: 25, blue: 170),
                        id: 1
    )
    
    /// A theme for emoji memory game
    static let food = Theme(name: "Food",
                        content: ["🍎", "🍉", "🍟", "🍕", "🌮", "🥟", "🍤", "🍗", "🧀", "🥝", "🍿", "🍪"],
                        numberOfPairsOfCards: 6,
                        color: Color(red: 255, green: 111, blue: 0),
                        id: 2
    )
    
    /// A theme for emoji memory game
    static let animals = Theme(name: "Animals",
                        content: ["🐱", "🐶", "🐢", "🐠", "🐝", "🦄", "🐣", "🦁", "🙉", "🐸", "🐼", "🦊", "🐷", "🐈"],
                        numberOfPairsOfCards: 5,
                        color: Color(red: 102, green: 194, blue: 147),
                        id: 3
    )
    
    /// A theme for emoji memory game
    static let drinks = Theme(name: "Drinks",
                        content: ["🧃", "🍺", "🍹", "🧉", "🍾", "🍷", "🥃", "🥛", "🧋", "🥤", "🍸"],
                        numberOfPairsOfCards: 6,
                        color: Color(red: 255, green: 167, blue: 163),
                        id: 4
    )
    
    /// A theme for emoji memory game
    static let red = Theme(name: "Red",
                        content: ["🌹", "🍎", "🍓", "🥊", "🎸", "🚗", "🚒", "🗼", "☎️", "🧨", "🎈"],
                        numberOfPairsOfCards: 8,
                        color: Color(red: 255, green: 71, blue: 86),
                        id: 5
    )
    
    /// A theme for emoji memory game
    static let summer = Theme(name: "Summer",
                        content: ["☀️", "🍹", "🏐", "🏄‍♂️", "🏝", "⛱", "🕶", "🧳", "🥽", "🐚", "🌊", "🚤"],
                        numberOfPairsOfCards: 8,
                        color: Color(red: 9, green: 189, blue: 176),
                        id: 6
    )
}
