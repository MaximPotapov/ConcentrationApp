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
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes : [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(string: "\(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBAction func newGameButton() {
        game.resetGame()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
        flipCount = 0
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
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
        scoreLabel.text = " \(game.score)"
    }
    
    private var emojiChoices = ["👁","🧟","🕸","🌚","🔦","🕯"]
     
    private  var emoji = [Card: String]()
    
    private var emojiThemes: [String: [String]] = [
        "Halloween" : ["👁","🧟","🕸","🌚","🔦","🕯", "🕷", "🎃"],
        "Fruits" : ["🍏","🍐","🍊","🍋","🍌","🍓", "🍒", "🍍"],
        "Vegatables" : ["🍆","🍅","🧅","🥕","🥔","🥒", "🌶", "🌽"],
        "Sport" : ["⚽️","🏀","🏈","🎾","🏐","🥏", "🏓", "🎱"],
        "Transport" : ["🚗","🏎","🛵","🏍","🚌","🚚", "🚃", "🚙"],
        "Flags" : ["🏳️‍🌈","🇲🇶","🇳🇫","🇷🇪","🇾🇹","🇦🇴", "🏴‍☠️", "🇺🇳"]
    ]
    
    private var indexTheme = 0 {
        didSet {
            print(indexTheme, keys[indexTheme])
            emojiChoices = emojiThemes[keys[indexTheme]] ?? []
            emoji = [Card : String]()
        }
    }
    
    private var keys: [String]{return Array(emojiThemes.keys)}
    
    private  func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
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
