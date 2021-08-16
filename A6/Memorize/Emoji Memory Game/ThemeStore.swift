//
//  ThemeStore.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-07.
//

import SwiftUI

/// Represents a ViewModel for storing and interacting with emoji memory game themes
class ThemeStore: ObservableObject {
    typealias Theme = MemoryGameTheme<String>
    
    /// Name of the theme store used for storing in User Defaults
    var name: String
    
    /// Array of all stored themes for Memorize
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    /// Key for storing themes in User Defaults
    var userDefaultsKey: String {
        "EmojiMemoryGameThemes" + name
    }
    
    /// Creates a new theme store for emoji memory game.
    /// If some theme store with matching 'name'  is found in User Defaults, all the data is automatically synchronised, otherwise default set of themes is loaded
    /// - Parameter name: Name of the theme store. Used for data persistence
    init(name: String) {
        self.name = name
        
        restoreFromUserDefaults()
        if themes.isEmpty {
            for theme in DefaultEmojiThemes.all {
                insertTheme(named: theme.name, emojis: theme.content, numberOfPairsOfCards: theme.numberOfPairsOfCards, color: Color(theme.color))
            }
        }
    }
    
    /// Finds for a matching theme store in User Defaults by a 'name' of the theme store and synchronises the data from it
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    /// Saves all the themes in User Defaults
    private func storeInUserDefaults() {
        UserDefaults.standard.setValue(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    /// Returns an index in the theme array that is guaranteed to be in boundaries of the array
    /// - Parameter index: index at the themes array
    /// - Returns: 'index' if index is in the boundaries of the themes array. Otherwise: zero - if 'index' is negative; index of the last element - if 'index' is higher than index of the last element
    private func safeIndex(index: Int) -> Int {
        min(max(index, 0), themes.count - 1)
    }
    
    // MARK: - Intents
    
    /// Returns theme at the given index
    /// - NOTE: If the index is out the bounds of the themes array,  either first or last element is returned
    /// - Parameter index: Index of the theme at 'themes' array
    /// - Returns: 'Theme' at the given 'index'. If the given index is out of bounds of the 'themes' array, either first or last element is returned
    func theme(at index: Int) -> Theme {
        let safeIndex = safeIndex(index: index)
        return themes[safeIndex]
    }
    
    /// Deletes theme at the given index
    /// - Parameter index: Index of the theme to delete
    func removeTheme(at index: Int) {
        if themes.indices.contains(index) {
            themes.remove(at: index)
        }
    }
    
    /// Inserts a new theme into theme store
    /// - Parameters:
    ///   - name: Name of the theme
    ///   - emojis: Array of emojis that will present on game cards
    ///   - numberOfPairsOfCards: how many pairs of cards will appear at the start of the game
    ///   - color: Color of theme
    func insertTheme(named name: String, emojis: [String], numberOfPairsOfCards: Int, color: Color) {
        let uniqueId = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1 // Generates a unique id for a new theme, that is basically the highest current id + 1
        
        let newTheme = Theme(name: name,
                             content: emojis,
                             numberOfPairsOfCards: numberOfPairsOfCards,
                             color: MemoryGameTheme<String>.RGBAColor(color),
                             id: uniqueId)
        
        themes.append(newTheme)
    }
    
    /// Removes the chosen theme at particular offset in the themes array
    /// - Parameter offset: theme's offset
    func removeTheme(atOffset offset: IndexSet) {
        themes.remove(atOffsets: offset)
    }
    
    /// Moves the chosen theme with offset 'fromOffset' to new offset 'toOffset'
    /// - Parameters:
    ///   - fromOffsets: old offset
    ///   - toOffset: new offset
    func moveTheme(fromOffsets source: IndexSet, toOffset destination: Int) {
        themes.move(fromOffsets: source, toOffset: destination)
    }
    
    /// Creates a new theme with default preset name, content, number of pairs of cards and color
    /// - Returns: ID of a created theme
    func createNewTheme() -> Theme? {
        insertTheme(named: "New theme",
                    emojis: DefaultEmojiThemes.various.content,
                    numberOfPairsOfCards: DefaultEmojiThemes.various.numberOfPairsOfCards,
                    color: Color(DefaultEmojiThemes.various.color))
        return themes.last
    }
}

extension Color {
    /// Creates a Color from MemoryGameTheme RGBAColor value
    /// - Parameter rgbaColor: MemoryGameTheme RGBAColor value with RGB values from 0 to 255 and opacity value from 0 to 1
    init<CardContent: Codable>(_ rgbaColor: MemoryGameTheme<CardContent>.RGBAColor) {
        self.init(.sRGB, red: rgbaColor.red / 255, green: rgbaColor.green / 255, blue: rgbaColor.blue / 255, opacity: rgbaColor.alpha)
    }
}

extension MemoryGameTheme.RGBAColor {
    /// Creates a RGBA Color value from SwiftUI Color value, where RGB values are from 0 to 255 and opacity value is from 0 to 1
    /// - Parameter color: SwiftUI Color value
    init(_ color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        
        self.init(red: Double(red) * 255, green: Double(green) * 255, blue: Double(blue) * 255, alpha: Double(alpha))
    }
}

extension MemoryGameTheme where CardContent == String {
    var contentAsString: String {
        get {
            String(self.content)
        }
        set {
            var newArrayOfStrings = [String]()
            for character in newValue {
                newArrayOfStrings.append(String(character))
            }
            self.content = newArrayOfStrings
        }
    }
}

extension MemoryGameTheme {
    var colorAsSwiftUIColor: Color {
        get {
            Color(self.color)
        }
        set {
            self.color = RGBAColor(newValue)
        }
    }
}
