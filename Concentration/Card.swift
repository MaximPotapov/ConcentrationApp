//
//  Card.swift
//  Concentration
//
//  Created by Maxim Potapov on 01.07.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//

import Foundation

struct Card: Hashable { // value type
    
    
    var hashValue: Int {return identifier}

    static func == (lhs: Card,rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    var isFaceUp = false // started pos not face up fo each card
    var isMatched = false // started pos not matched for each card
    private var identifier: Int // unique card id
    
    private static var identifierFactory = 0 // store each card uqiaue identifier
    
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
