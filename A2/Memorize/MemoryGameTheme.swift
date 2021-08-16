//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-06-25.
//

import Foundation

struct MemoryGameTheme <CardContent> {
    /// Initializes the theme for memory game that 'numberOfPairsOfCards' is equals to the count of 'cardIcons'
    /// - Parameter name: name of the theme
    /// - Parameter cardIcons: array consisting of unique content for each pair of card
    /// - Parameter mainColor: color name for theme, for example, "green"
    /// - Parameter cardsColor: color name for cards, might be a gradient, for example, "green-blue"
    init(name: String, cardIcons: [CardContent], themeColor: String, cardsColor: String) {
        self.name = name
        self.cardIcons = cardIcons
        self.mainColor = themeColor
        self.cardsColor = cardsColor
        numberOfPairsOfCards = cardIcons.count
    }
    
    /// Initializes the theme for memory game
    /// - Parameter name: name of the theme
    /// - Parameter cardIcons: array consisting of unique content for each pair of card
    /// - Parameter numberOfPairsOfCards: number of pairs of cards in the game
    /// - Parameter mainColor: color name for theme, for example, "green"
    /// - Parameter cardsColor: color name for cards, might be a gradient, for example, "green-blue"
    /// - Note: if 'numberOfPairsOfCards' is greater than count of 'cardIcons' its' value will equal to count of 'cardIcons'
    init(name: String, cardIcons: [CardContent], numberOfPairsOfCards: Int, themeColor: String, cardsColor: String) {
        if numberOfPairsOfCards > cardIcons.count {
            self.numberOfPairsOfCards = cardIcons.count
        }
        
        self.name = name
        self.cardIcons = cardIcons
        self.mainColor = themeColor
        self.cardsColor = cardsColor
        self.numberOfPairsOfCards = numberOfPairsOfCards
    }
    
    /// Initializes the theme for memory game, where 'numberOfPairsOfCards' is a random value between 'numberOfPairsOfCardsMin' and 'numberOfPairsOfCardsMax'
    /// - Parameter name: name of the theme
    /// - Parameter cardIcons: array consisting of unique content for each pair of card
    /// - Parameter numberOfPairsOfCardsMin: minimal value number of pairs of cards in the game
    /// - Parameter numberOfPairsOfCardsMax: maximum value number of pairs of cards in the game
    /// - Parameter mainColor: color name for theme, for example, "green"
    /// - Parameter cardsColor: color name for cards, might be a gradient, for example, "green-blue"
    /// - Note: Swift Int.random(in: range<Int>) is used for random value generation
    init(name: String, cardIcons: [CardContent], numberOfPairsOfCardsMin: Int, numberOfPairsOfCardsMax: Int, themeColor: String, cardsColor: String) {
        self.name = name
        self.cardIcons = cardIcons
        self.mainColor = themeColor
        self.cardsColor = cardsColor
        self.numberOfPairsOfCards = Int.random(in: numberOfPairsOfCardsMin...numberOfPairsOfCardsMax)
    }
    
    var name: String /// name of the theme
    var cardIcons: [CardContent] /// array consisting of unique content for each pair of card
    var numberOfPairsOfCards: Int /// number of pairs of cards in the game
    var mainColor: String /// color of the theme
    var cardsColor: String /// color of cards
}
