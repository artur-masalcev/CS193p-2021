//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-27.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    init() {
        //Adding themes to the emoji memory game//
        
        themes.append(EmojiMemoryGameThemes.various)
        themes.append(EmojiMemoryGameThemes.food)
        themes.append(EmojiMemoryGameThemes.animals)
        themes.append(EmojiMemoryGameThemes.halloween)
        themes.append(EmojiMemoryGameThemes.drinks)
        themes.append(EmojiMemoryGameThemes.red)
        themes.append(EmojiMemoryGameThemes.summer)
        
        //Game starts with random theme//
        
        if let randomTheme = themes.randomElement() {
            model = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
            theme = randomTheme
        } else {
            model = EmojiMemoryGame.createMemoryGame(theme: themes[0])
            theme = themes[0]
        }
        
        mainColor = EmojiMemoryGame.toSwiftUIColor(theme.mainColor, defaultValue: .yellow)
        cardsColor = EmojiMemoryGame.toSwiftUILinearGradient(theme.cardsColor, defaultValue: LinearGradient(gradient: Gradient(colors: [Color.yellow]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
    }
    
    /// Converts name of the color in String format to SwiftUI Color value. If the given text string matches no color in the database, 'defaultValue' is returned
    /// - Parameter _ : the String value of name of the color
    /// - Parameter defaultValue: the default value to be returned if no matching color is found in the database
    private static func toSwiftUIColor(_ colorName: String, defaultValue: Color) -> Color {
        switch colorName {
        case "red":
            return .red
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "blue":
            return .blue
        case "purple":
            return .purple
        case "black":
            return .black
        default:
            return defaultValue
        }
    }

    /// Converts name of the color in String format to SwiftUI LinearGradient value. If the given text string mathches no color in the database 'defaultValue' is returned
    /// - Parameter _: the String value of name of the color
    /// - Parameter defaultValue: the default value to be returned if no matching color is found in the database
    private static func toSwiftUILinearGradient(_ gradientName: String, defaultValue: LinearGradient) -> LinearGradient {
        switch gradientName {
        case "red":
            return LinearGradient(gradient: Gradient(colors: [Color.red]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "orange":
            return LinearGradient(gradient: Gradient(colors: [Color.orange]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "yellow":
            return LinearGradient(gradient: Gradient(colors: [Color.yellow]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "green":
            return LinearGradient(gradient: Gradient(colors: [Color.green]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "blue":
            return LinearGradient(gradient: Gradient(colors: [Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "purple":
            return LinearGradient(gradient: Gradient(colors: [Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "black":
            return LinearGradient(gradient: Gradient(colors: [Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "orange-red":
            return LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "black-orange":
            return LinearGradient(gradient: Gradient(colors: [Color.black, Color.orange]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        case "blue-green":
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        default:
            return defaultValue
        }
    }
    
    /// Contains all the used themes in the emoji type memory game
    private var themes = [MemoryGameTheme<String>]()
    
    /// Creates and returns a new emoji memory game based on a given 'theme'
    /// - Parameter theme: the theme to be used in game
    static func createMemoryGame(theme: MemoryGameTheme<String>) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in theme.cardIcons[pairIndex]}
    }
    
   @Published private var model: MemoryGame<String>
    
    /// Memory game cards
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    /// Memory game score
    var score: Int {
        model.score
    }
    
    /// Memory game theme
    var theme: MemoryGameTheme<String>
    
    /// Current theme color
    var mainColor: Color
    
    /// Current cards color represented in SwiftUI LinearGradient
    var cardsColor: LinearGradient
    
    // MARK: - Intent(s)
    
    /// Processes user's interaction with a game card
    /// - Parameter _: the chosen card
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    /// Restarts the game with a new random set of cards and new random theme
    func startNewGame() {
        let randomTheme = themes.randomElement() ?? themes[0]
        
        mainColor = EmojiMemoryGame.toSwiftUIColor(randomTheme.mainColor, defaultValue: .yellow)
        theme = randomTheme
        cardsColor = EmojiMemoryGame.toSwiftUILinearGradient(randomTheme.cardsColor, defaultValue: LinearGradient(gradient: Gradient(colors: [Color.yellow]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
        model = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
    }
}
