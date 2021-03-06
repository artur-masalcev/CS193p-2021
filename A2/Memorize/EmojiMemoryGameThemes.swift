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
        cardIcons: ["๐ฅณ", "๐ฅฐ", "๐คฏ", "๐ฆ","๐ฅถ","๐คฅ","๐ ","๐","๐พ","๐ป",
                                "๐","๐","๐","๐","๐ณ","๐ฆ","๐","๐","๐ท","๐ฅ"],
        numberOfPairsOfCardsMin: 4,
        numberOfPairsOfCardsMax: 8,
        themeColor: "yellow",
        cardsColor: "yellow"
    )
    
    static let food = MemoryGameTheme<String>(
        name: "Food",
        cardIcons: ["๐", "๐", "๐", "๐", "๐ฎ", "๐ฅ", "๐ค", "๐", "๐ง", "๐ฅ", "๐ฟ", "๐ช"],
        numberOfPairsOfCards: 6,
        themeColor: "orange",
        cardsColor: "orange-red"
    )
    
    static let animals = MemoryGameTheme<String>(
        name: "Animals",
        cardIcons: ["๐ฑ", "๐ถ", "๐ข", "๐ ", "๐", "๐ฆ", "๐ฃ", "๐ฆ", "๐", "๐ธ", "๐ผ", "๐ฆ", "๐ท", "๐"],
        numberOfPairsOfCards: 5,
        themeColor: "green",
        cardsColor: "green"
    )
    
    static let halloween = MemoryGameTheme<String>(
        name: "Halloween",
        cardIcons: ["๐ธ", "๐ป", "๐", "๐คก", "๐น", "๐ฌ", "๐", "๐ฑ", "๐งโโ๏ธ"],
        numberOfPairsOfCards: 7,
        themeColor: "orange",
        cardsColor: "black-orange")
    
    static let drinks = MemoryGameTheme<String>(
        name: "Drinks",
        cardIcons: ["๐ง", "๐บ", "๐น", "๐ง", "๐พ", "๐ท", "๐ฅ", "๐ฅ", "๐ง", "๐ฅค", "๐ธ"],
        numberOfPairsOfCards: 6,
        themeColor: "purple",
        cardsColor: "purple"
    )
    
    static let red = MemoryGameTheme<String>(
        name: "Red",
        cardIcons: ["๐น", "๐", "๐", "๐ฅ", "๐ธ", "๐", "๐", "๐ผ", "โ๏ธ", "๐งจ", "๐"],
        numberOfPairsOfCards: 8,
        themeColor: "red",
        cardsColor: "red"
    )
    
    static let summer = MemoryGameTheme<String>(
        name: "Summer",
        cardIcons: ["โ๏ธ", "๐น", "๐", "๐โโ๏ธ", "๐", "โฑ", "๐ถ", "๐งณ", "๐ฅฝ", "๐", "๐", "๐ค"],
        numberOfPairsOfCards: 5,
        themeColor: "blue",
        cardsColor: "blue-green"
    )
}
