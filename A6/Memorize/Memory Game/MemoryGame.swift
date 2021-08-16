//
//  MemoryGame.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-27.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: [Card] /// Represent all the cards of memory game
    public var score = 0 /// Represent the score of the game
    
    private var indexOfTheOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            cards.indices.forEach {
                cards[$0].isFaceUp = ($0 == newValue)
            }
        } 
    }
    
    private var lastCardMatchTime: Date
    
    /// Initialises a new memory game with given number of pairs of cards and rule how to apply cards content to each card
    /// - Parameter numberOfPairsOfCards: how many pairs of cards will be in the game
    /// - Parameter createCardContent: defines how the index of a particular card connected to its content
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        
        cards.shuffle()
        
        lastCardMatchTime = Date()
    }
    
    /// Processes user's interaction with a chosen 'card'. Rules the logic of the game
    /// - Parameter _: the chosen card
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    //Player gets rewarded if they quickly matches the cards//
                    let timeIntervalSinceLastMatch = lastCardMatchTime.timeIntervalSince(Date())
                    score += max(10 - Int(-timeIntervalSinceLastMatch), 2)
                    self.lastCardMatchTime = Date()
                } else {
                    
                    //Player gets a penalty if opens a card that been already showed//
                    if cards[chosenIndex].isSeen {
                        score -= 1
                    }
                    
                    if cards[potentialMatchIndex].isSeen {
                        score -= 1
                    }
                    
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                }
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    /// Representation of memory game card
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    /// If the array contains one and only element returns this element, otherwise returns nil
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
