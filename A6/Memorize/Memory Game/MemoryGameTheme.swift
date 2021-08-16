//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-06-25.
//

import Foundation

/// UI independent representation of theme for a card-matching memory game
struct MemoryGameTheme<CardContent: Codable & Hashable> : Codable, Identifiable, Hashable {
    /// Name of the theme
    var name: String
    
    /// Array consisting of unique content for each pair of cards
    var content: [CardContent] {
        didSet {
            // Number of elements in content cannot be less than two //
            if content.count < 2 {
                self.content = oldValue
            }
            
            // Number of pairs of cards cannot be more than number of unique card content //
            if numberOfPairsOfCards > content.count {
                numberOfPairsOfCards = content.count
            }
            
            // Content for each theme cannot contain duplicate elements //
            self.content = content.uniqued()
            
            // Update recently removed content //
            setRemovedContent(oldContentValue: oldValue)
        }
    }
    
    /// Number of pairs of cards in the game. Cannot be less than 2 or more than number of elements in cards content array (i.e. 'self.content')
    var numberOfPairsOfCards: Int {
        didSet {
            // Number of pairs of cards cannot be more than number of unique card content nor less than two //
            if numberOfPairsOfCards > content.count {
                numberOfPairsOfCards = content.count
            }
            if numberOfPairsOfCards < 2 {
                numberOfPairsOfCards = 2
            }
        }
    }
    
    /// Color of the theme
    var color: RGBAColor
    
    /// Unique id of the theme
    var id: Int
    
    /// Card content that been removed from theme
    var removedContent: Set<CardContent> = []
    
    /// Updates 'removedContent' by extracting removed card content from old and new 'content' values
    /// - Parameter oldContentValue: previous value of 'content' to compare with
    private mutating func setRemovedContent(oldContentValue: [CardContent]) {
        if content.count < oldContentValue.count {
            let recentlyRemovedContent = oldContentValue.filter({ !content.contains($0) })
            for removedElement in recentlyRemovedContent {
                removedContent.insert(removedElement)
            }
        }
    }
    
    /// Representation of a RGBA color value
    /// - Note: 'RGBAColor' does not demand for color value to be in some range (for example, in 8 bit model case from 0 to 255). Thus color values may be in a whole 'Double' type range
    struct RGBAColor: Codable, Equatable, Hashable {
        var red: Double
        var green: Double
        var blue: Double
        var alpha: Double
        
        /// Creates a RGBA color value with given red, green, blue and alpha (opacity) values. 'alpha' value is set to 1 by default (no transparency)
        /// - Parameters:
        ///   - red: intensity value of red color
        ///   - green: intensity value of green color
        ///   - blue: intensity value of blue color
        init(red: Double, green: Double, blue: Double, alpha: Double = 1){
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
    
    /// Compares two themes by their IDs
    /// - Parameters:
    ///   - lhs: first theme
    ///   - rhs: second theme
    /// - Returns: 'true' if both IDs are matching. 'false' otherwise
    static func == (lhs: MemoryGameTheme<CardContent>, rhs: MemoryGameTheme<CardContent>) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Checks whether the theme is fully identical to other
    /// - Parameter theme: theme to compare with
    /// - Returns: 'true' if id, content, number of pairs of cards, color and name is same for both themes
    func equals(to theme: MemoryGameTheme) -> Bool {
        self.id == theme.id &&
            self.content == theme.content &&
            self.numberOfPairsOfCards == theme.numberOfPairsOfCards &&
            self.color == theme.color &&
            self.name == theme.name
    }
    
    /// Creates a hash value for the given theme
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

