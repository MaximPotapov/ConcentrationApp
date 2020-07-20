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
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let ch = "h".oneAndOnly
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly // bool func executed by closure -> return true if card in index is face up.
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                         return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue )
            }
        }
    }
    
    mutating func chooseCard(at index: Int)  { // choose card by its index ( not emoji)
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index): no such index")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
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
        
        // TO DO: SHUFFLE CARDS
            
    }
    
    func setNumberOfPairs(of cards: Int) {
        
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil 
    }
}
