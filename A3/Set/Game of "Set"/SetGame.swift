//
//  SetGame.swift
//  Set
//
//  Created by Artur Masalcev on 2021-06-30.
//

import Foundation

struct SetGame {
    
    private static let numberOfCardsAtTheStartOfTheGame = 12
    private static let numberOfCardsInASet = 3
    private static let scoreForAMatch = 10
    private static let penaltyForMistake = 3
    private static let penaltyForUnnecessaryDeal = 2
    private static let scoreForSpeed = 30
    
    private var deck: [Card]
    var cardsOnTheTable: [Card]
    var numberOfSelectedCards: Int = 0
    
    var score = 0
    private var lastMatchTime: Date
    
    /// Creates a new game of Set with a random-order deck and cards on the table
    init() {
        lastMatchTime = Date()
        
        deck = SetGame.generateNewDeck()
        
        cardsOnTheTable = [Card]()
        
        for _ in 0 ..< SetGame.numberOfCardsAtTheStartOfTheGame {
            if let cardAtTheTop = getCardOutOfDeck() {
                cardsOnTheTable.append(cardAtTheTop)
            }
        }
    }
    
    /// Processes and handles user's interaction with a card on the table
    /// - Parameter card: the chosen card from the table
    mutating func choose(_ card: Card) {
        //Handle the situation where 3 cards are already chosen//
        if(numberOfSelectedCards >= SetGame.numberOfCardsInASet) {
            if(!card.isSelected){
                
                deleteMatchedCards()
                deselectAllCardsOnTheTable()
                
                guard let indexOfTheChosenCard = cardsOnTheTable.firstIndex(where: {$0.id == card.id}) else {
                    return
                }
                
                cardsOnTheTable[indexOfTheChosenCard].isHighlighted = false
                cardsOnTheTable[indexOfTheChosenCard].isSelected = true
                numberOfSelectedCards = 1
            }
            
            return
        }
        
        guard let indexOfTheChosenCard = cardsOnTheTable.firstIndex(where: {$0.id == card.id}) else {
            return
        }
        
        if card.isSelected {
            cardsOnTheTable[indexOfTheChosenCard].isSelected = false
            numberOfSelectedCards -= 1
        } else {
            cardsOnTheTable[indexOfTheChosenCard].isHighlighted = false
            cardsOnTheTable[indexOfTheChosenCard].isSelected = true
            numberOfSelectedCards += 1
            
            if numberOfSelectedCards == SetGame.numberOfCardsInASet {
                let selectedCards = cardsOnTheTable.filter({$0.isSelected})
                if areMakingSet(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2]) {
                    for index in 0...2 {
                        let indexOfSelectedCard = cardsOnTheTable.firstIndex(where: {$0.id == selectedCards[index].id})
                        cardsOnTheTable[indexOfSelectedCard!].isMatched = true
                    }
                    
                    //Player gets rewarded if they quickly match cards//
                    let timeIntervalSinceLastMatch = lastMatchTime.timeIntervalSince(Date())
                    increaseScore(by: max(SetGame.scoreForSpeed - Int(-timeIntervalSinceLastMatch), SetGame.scoreForAMatch))
                    dealThreeMoreCards()
                } else {
                    for index in 0...2 {
                        let indexOfSelectedCard = cardsOnTheTable.firstIndex(where: {$0.id == selectedCards[index].id})
                        cardsOnTheTable[indexOfSelectedCard!].isMatched = false
                    }
                    
                    decreaseScore(by: SetGame.penaltyForMistake)
                }
            }
        }
    }
    
    /// Adds three more cards on the table and removes them from the deck
    mutating func dealThreeMoreCards() {
        deleteMatchedCards()
        
        if deck.isEmpty { return }
        
        for _ in 0...2 {
            if let newCard = deck.popLast() {
                cardsOnTheTable.append(newCard)
            }
        }
        
        if let _ = findASet(cards: cardsOnTheTable) {
            decreaseScore(by: SetGame.penaltyForUnnecessaryDeal)
        }
    }
    
    /// Finds and highlights a set if there are any on the table. If not set is found, automatically draws three cards
    mutating func hint() {
        guard let cardsInSet = findASet(cards: cardsOnTheTable) else {
            dealThreeMoreCards()
            return
        }
        
        deselectAllCardsOnTheTable()
        
        if let indexOfFirstMatchedCard = cardsOnTheTable.firstIndex(where: { $0.id == cardsInSet.firstCard.id }) {
            cardsOnTheTable[indexOfFirstMatchedCard].isHighlighted = true
        }
        
        if let indexOfSecondMatchedCard = cardsOnTheTable.firstIndex(where: { $0.id == cardsInSet.secondCard.id }) {
            cardsOnTheTable[indexOfSecondMatchedCard].isHighlighted = true
        }
        
        if let indexOfThirdMatchedCard = cardsOnTheTable.firstIndex(where: { $0.id == cardsInSet.thirdCard.id }) {
            cardsOnTheTable[indexOfThirdMatchedCard].isHighlighted = true
        }
    }
    
    /// Deselects all the cards on the table
    private mutating func deselectAllCardsOnTheTable() {
        for index in cardsOnTheTable.indices {
            cardsOnTheTable[index].isSelected = false
            cardsOnTheTable[index].isMatched = nil
        }
        numberOfSelectedCards = 0
    }
    
    /// Deletes and returns a card from the deck
    /// - Returns: a card from the deck
    private mutating func getCardOutOfDeck() -> Card? {
        return deck.popLast()
    }
    
    /// Generates new deck of cards with random order for the game of Set
    /// - Returns: 81 cards with random order for the game of Set
    private static func generateNewDeck() -> [Card] {
        var deck = [Card]()
        var idCounter = 0 //Increments each time a new card is created, each card will have a unique id that equals to 'idCounter'
        
        //Go through each possible variation of a card//
        for number in Number.allCases {
            for shape in Shape.allCases {
                for color in Color.allCases {
                    for shading in Shading.allCases {
                        deck.append(Card(number: number, shape: shape, color: color, shading: shading, id: idCounter))
                        idCounter += 1
                    }
                }
            }
        }
        
        deck.shuffle()
        
        return deck
    }
    
    /// Checks if three given cards are making a set by the rules of the game of Set
    /// - Note: function does not check whether some or all of the cards are equal
    /// - Parameters:
    ///   - firstCard: first card
    ///   - secondCard: second card
    ///   - thirdCard: third card
    /// - Returns: 'true' if three given cards are making a set. 'False' otherwise
    private func areMakingSet(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        
        func areAllEqual<Type: Equatable>(_ first: Type, _ second: Type, _ third: Type) -> Bool {
            (first == second) && (second == third)
        }
        
        func areAllDifferent<Type: Equatable>(_ first: Type, _ second: Type, _ third: Type) -> Bool {
            (first != second) && (second != third) && (third != first)
        }
        
        if !areAllEqual(firstCard.number, secondCard.number, thirdCard.number) &&
            !areAllDifferent(firstCard.number, secondCard.number, thirdCard.number) {
            return false
        }
        
        if !areAllEqual(firstCard.shape, secondCard.shape, thirdCard.shape) &&
            !areAllDifferent(firstCard.shape, secondCard.shape, thirdCard.shape) {
            return false
        }
        
        if !areAllEqual(firstCard.color, secondCard.color, thirdCard.color) &&
            !areAllDifferent(firstCard.color, secondCard.color, thirdCard.color) {
            return false
        }
        
        if !areAllEqual(firstCard.shading, secondCard.shading, thirdCard.shading) &&
            !areAllDifferent(firstCard.shading, secondCard.shading, thirdCard.shading) {
            return false
        }
        
        return true
    }
    
    /// Deletes matched cards from the table
    private mutating func deleteMatchedCards() {
        cardsOnTheTable = cardsOnTheTable.filter({$0.isMatched == false || $0.isMatched == nil})
    }
    
    /// Finds and returns any set in the array of cards
    /// - Parameter cards: array of cards
    /// - Returns: Returns a tuple of three cards that make a set by the rules of the  game of set. Returns 'nil' if no set been found
    private func findASet(cards: [Card]) -> (firstCard: Card, secondCard: Card, thirdCard: Card)? {
        func areAllDifferent<Type: Equatable>(_ first: Type, _ second: Type, _ third: Type) -> Bool {
            (first != second) && (second != third) && (third != first)
        }
        
        for indexOfFirstCard in cards.indices {
            for indexOfSecondCard in cards.indices {
                for indexOfThirdCard in cards.indices {
                    if !areAllDifferent(indexOfFirstCard, indexOfSecondCard, indexOfThirdCard) { continue }
                    if areMakingSet(firstCard: cards[indexOfFirstCard],
                                    secondCard: cards[indexOfSecondCard],
                                    thirdCard: cards[indexOfThirdCard]) {
                        return (cards[indexOfFirstCard], secondCard: cards[indexOfSecondCard], thirdCard: cards[indexOfThirdCard])
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Decreases the score by 'penalty'. If score becomes negative, automatically sets it to zero
    /// - Parameter penalty: number of points for score to decrease
    private mutating func decreaseScore(by penalty: Int) {
        if(score - penalty >= 0) { score -= penalty }
        else { score = 0 }
    }
    
    /// Increases the score by 'bounty'
    /// - Parameter bounty: number of points for score to increase
    private mutating func increaseScore(by bounty: Int) {
        score += bounty
    }
    
    /// A card for UI independent game of Set
    struct Card: Identifiable {
        var number: Number
        var shape: Shape
        var color: Color
        var shading: Shading
        var isSelected = false
        var isMatched: Bool?
        var isHighlighted = false
        var id: Int
    }
    
    enum Number: CaseIterable {
        case one
        case two
        case three
    }
    
    enum Shape: CaseIterable {
        case first
        case second
        case third
    }
    
    enum Color: CaseIterable {
        case first
        case second
        case third
    }
    
    enum Shading: CaseIterable {
        case first
        case second
        case third
    }
    
}
