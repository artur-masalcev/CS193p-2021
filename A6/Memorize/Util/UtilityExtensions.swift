//
//  UtilityExtensions.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-09.
//

import Foundation

extension Collection where Element: Identifiable {
    /// Returns first index that matches 'element' in the array
    /// - Parameter element: Element to find
    /// - Returns: First index that matches 'element' in the array
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension Sequence where Element: Hashable {
    /// Returns Sequence that contains only unique elements
    /// - Returns: Sequence that contains only unique elements
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}

extension String {
    init(_ arrayOfStrings: [String]) {
        var combinedString = ""
        
        for string in arrayOfStrings {
            combinedString.append(string)
        }
        
        self = combinedString
    }
}

extension Character {
    /// Checks whether the character is emoji made with only one scalar
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks whether the character is emoji made with multiple scalars
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    
    /// Checks whether the character is emoji
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    /// Returns a string with only emojis in it
    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }
    
    /// Returns an array of characters with only emojis in it
    var emojis: [Character] {
        return filter { $0.isEmoji }
    }
}
