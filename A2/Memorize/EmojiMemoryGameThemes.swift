//
//  EmojiMemoryGameThemes.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-06-26.
//

import Foundation

struct EmojiMemoryGameThemes {
    static let various = MemoryGameTheme<String>(
        name: "Various",
        cardIcons: ["🥳", "🥰", "🤯", "🦁","🥶","🤥","🐠","🙄","👾","👻",
                                "👑","🎓","🐜","🐘","🐳","🦏","🎄","🍄","🌷","🔥"],
        numberOfPairsOfCardsMin: 4,
        numberOfPairsOfCardsMax: 8,
        themeColor: "yellow",
        cardsColor: "yellow"
    )
    
    static let food = MemoryGameTheme<String>(
        name: "Food",
        cardIcons: ["🍎", "🍉", "🍟", "🍕", "🌮", "🥟", "🍤", "🍗", "🧀", "🥝", "🍿", "🍪"],
        numberOfPairsOfCards: 6,
        themeColor: "orange",
        cardsColor: "orange-red"
    )
    
    static let animals = MemoryGameTheme<String>(
        name: "Animals",
        cardIcons: ["🐱", "🐶", "🐢", "🐠", "🐝", "🦄", "🐣", "🦁", "🙉", "🐸", "🐼", "🦊", "🐷", "🐈"],
        numberOfPairsOfCards: 5,
        themeColor: "green",
        cardsColor: "green"
    )
    
    static let halloween = MemoryGameTheme<String>(
        name: "Halloween",
        cardIcons: ["🕸", "👻", "💀", "🤡", "👹", "🍬", "🎃", "😱", "🧙‍♀️"],
        numberOfPairsOfCards: 7,
        themeColor: "orange",
        cardsColor: "black-orange")
    
    static let drinks = MemoryGameTheme<String>(
        name: "Drinks",
        cardIcons: ["🧃", "🍺", "🍹", "🧉", "🍾", "🍷", "🥃", "🥛", "🧋", "🥤", "🍸"],
        numberOfPairsOfCards: 6,
        themeColor: "purple",
        cardsColor: "purple"
    )
    
    static let red = MemoryGameTheme<String>(
        name: "Red",
        cardIcons: ["🌹", "🍎", "🍓", "🥊", "🎸", "🚗", "🚒", "🗼", "☎️", "🧨", "🎈"],
        numberOfPairsOfCards: 8,
        themeColor: "red",
        cardsColor: "red"
    )
    
    static let summer = MemoryGameTheme<String>(
        name: "Summer",
        cardIcons: ["☀️", "🍹", "🏐", "🏄‍♂️", "🏝", "⛱", "🕶", "🧳", "🥽", "🐚", "🌊", "🚤"],
        numberOfPairsOfCards: 5,
        themeColor: "blue",
        cardsColor: "blue-green"
    )
}
