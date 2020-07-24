//
//  Concentration.swift
//  Concentration
//
//  Created by Maxim Potapov on 01.07.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//
// MODEL Public API 

import Foundation

struct Concentration { // ref type
    private(set) var  cards = [Card]()
    
    private(set) var score = 0
    private var seenCards: Set<Int> = []
    
    private(set) var flipCount = 0
    
    private struct Points {
        static let matchCard = 2
        static let misMatchCard = 1
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let ch = "h".oneAndOnly
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly // bool
        }
        // 332
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue )
            }
        }
    }
    
    mutating func chooseCard(at index: Int)  { // choose card by its index ( not emoji)
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index): no such index")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    score += Points.matchCard // increase points if match
                } else {
                    if seenCards.contains(index) {
                        score -= Points.misMatchCard
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.misMatchCard
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
              
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                
            }
        }
    }
        
    
        init( numberOfPairsOfCard: Int) {
            assert(numberOfPairsOfCard > 0, "Concentration.chooseCard(at:\(numberOfPairsOfCard): u must have at least 1 pair of cards")
            for _ in 1...numberOfPairsOfCard {
                let card = Card()
                cards += [card, card]
            }
            cards.shuffleCards()
    }
    
    func setNumberOfPairs(of cards: Int) {
        
    }
    
    mutating func resetGame() {
        flipCount = 0
        score = 0
        seenCards = []
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            
        }
        cards.shuffleCards()
        seenCards.removeAll()
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil 
    }
}

extension Array {
    mutating func shuffleCards() {
        if count < 2 { return } // if collection empty or has 1 element -> no need to  shuffle
        
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: diff.arc4random)
            swapAt(i, j)
        }
    }
}

