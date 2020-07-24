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
// MARK: IBOutlets & Views
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel! // label assigmentc
    @IBOutlet private var cardButtons: [UIButton]! // array of buttons
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    
// MARK: - Properties
    private var keys: [String]{return Array(emojiThemes.keys)}
    private var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var cardBackColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    private var emojiChoices = ["👁","🧟","🕸","🌚","🔦","🕯"]
    private var emoji = [Card: String]()
    
    private lazy var game = Concentration(numberOfPairsOfCard: numberOfPairsOfCards) // connection between model and controller
      
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    private var emojiThemes: [String: Theme] = [
        "Halloween" : (["👁","🧟","🕸","🌚","🔦","🕯", "🕷", "🎃"],#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        "Fruits" : (["🍏","🍐","🍊","🍋","🍌","🍓", "🍒", "🍍"],#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
        "Vegatables" : (["🍆","🍅","🧅","🥕","🥔","🥒", "🌶", "🌽"],#colorLiteral(red: 0.8675883412, green: 0.7827435136, blue: 0.3818389773, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)),
        "Sport" : (["⚽️","🏀","🏈","🎾","🏐","🥏", "🏓", "🎱"],#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        "Transport" : (["🚗","🏎","🛵","🏍","🚌","🚚", "🚃", "🚙"],#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
        "Flags" : (["🏳️‍🌈","🇲🇶","🇳🇫","🇷🇪","🇾🇹","🇦🇴", "🏴‍☠️", "🇺🇳"],#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
    ]
    
    private var indexTheme = 0 {
        didSet {
            print(indexTheme, keys[indexTheme])
            themeLabel.text = keys[indexTheme]
            (emojiChoices, backgroundColor, cardBackColor) = emojiThemes[keys[indexTheme]] ?? ([], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
            emoji = [Card : String]()
            
            updateAppearence()
        }
    }
    
    private(set) var flipCount = 0 {
        didSet { // everytime flipCount value changes -> change text label
            updateFlipCountLabel()
        }
    }
    
    typealias Theme = (emojiChoices: [String], backgroundColor: UIColor, cardBackColor: UIColor)
    
// MARK: - Delegates
    
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
    
// MARK: - IBActions & Button target actions
    @IBAction func newGameButtonAction() {
        game.resetGame()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
        flipCount = 0
    }
    
    @IBAction private  func touchCard(_ sender: UIButton) { // touch func
        // print("Hi there!")
         //flipCount += 1
         if let cardNumber = cardButtons.firstIndex(of: sender) { // if card in arr -> send message
            // print("Card number \(cardNumber) ")\
             game.chooseCard(at: cardNumber)
             updateViewFromModel()
         } else { // if card is not in arr -> send message
             print("The card you picker is not in the array!")
         }
     }

// MARK: - Open Methods
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                

            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : cardBackColor
            }
        }
        scoreLabel.text = " \(game.score)"
        flipCountLabel.text = "\(game.flipCount)"
    }
   
       
      
       
  
   
    private func updateFlipCountLabel() {
        let attributes : [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : cardBackColor
        ]
        
        let attributedString = NSAttributedString(string: "\(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
// MARK: - Private methods
    private func updateAppearence() {
       view.backgroundColor = backgroundColor
       flipCountLabel.textColor = cardBackColor
       scoreLabel.textColor = cardBackColor
       themeLabel.textColor = cardBackColor
       newGameButton.setTitleColor(backgroundColor, for: .normal)
       newGameButton.backgroundColor = cardBackColor
    }
    
     
        private  func emoji(for card: Card) -> String {
            if emoji[card] == nil {
                let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
                emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            }
            return emoji[card] ?? "?"
        }
    }
    
// MARK: - Delegate conformance
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

   

 


