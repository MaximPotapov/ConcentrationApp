//
//  ViewController.swift
//  Concentration
//
//  Created by Maxim Potapov on 26.06.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//
// CONTROLLER
import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCard: numberOfPairsOfCards) // connection between model and controller
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    
    private(set) var flipCount = 0 {
        didSet { // everytime flipCount value changes -> change text label
            flipCountLabel.text = "\(flipCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! // label assigmentc
    
    @IBOutlet private var cardButtons: [UIButton]! // array of buttons
    
    @IBAction private  func touchCard(_ sender: UIButton) { // touch func
       // print("Hi there!")
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) { // if card in arr -> send message
           // print("Card number \(cardNumber) ")\
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else { // if card is not in arr -> send message
            print("The card you picker is not in the array!")
        }
        
    } // end of touch func
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = ["👁","🧟","🕸","🕷","🌚","🔦","🕯"]
     
    private  var emoji = [Card: String]()
    
    private  func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
        return Int(arc4random_uniform(UInt32(self)))
            
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))

        } else {
            return 0
        }
    }
}
