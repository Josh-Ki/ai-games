//
//  TicTacToeViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
//MARK: This View controller creates the tic tac toe board and allows for users to switch between x and o in order to play.

import UIKit

class TicTacToeViewController: UIViewController {
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var r1c1: UIButton!
    @IBOutlet weak var r1c2: UIButton!
    @IBOutlet weak var r1c3: UIButton!
    @IBOutlet weak var r2c1: UIButton!
    @IBOutlet weak var r2c2: UIButton!
    @IBOutlet weak var r2c3: UIButton!
    @IBOutlet weak var r3c1: UIButton!
    @IBOutlet weak var r3c2: UIButton!
    @IBOutlet weak var r3c3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    var firstTurn = TicTacToeTurn.x
    var currentTurn = TicTacToeTurn.x
    
    var o = "O"
    var x = "X"
    var oScore = 0
    var xScore = 0
    var board = [UIButton]()
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        addToBoard(sender)
        if victory(x){
            xScore += 1
            resultAlert(title: "X WINS")
        }
        if victory(o){
            oScore += 1
            resultAlert(title: "O Wins")
        }
        if(boardIsFull()){
            resultAlert(title: "Draw")
            
        }
        
    }
    func initBoard() {
        board.append(r1c1)
        board.append(r1c2)
        board.append(r1c3)
        board.append(r2c1)
        board.append(r2c2)
        board.append(r2c3)
        board.append(r3c1)
        board.append(r3c2)
        board.append(r3c3)
    }
    func resultAlert(title:String){
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == TicTacToeTurn.o {
            firstTurn = TicTacToeTurn.x
            turnLabel.text = x
        }
        else if firstTurn == TicTacToeTurn.x {
            firstTurn = TicTacToeTurn.o
            turnLabel.text = o
        }
        currentTurn = firstTurn
    }
    func boardIsFull() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    func addToBoard(_ sender: UIButton){
        if(sender.title(for: .normal) == nil){
            if(currentTurn == TicTacToeTurn.o){
                
                sender.setTitle(o, for: .normal)

                
                
                currentTurn = TicTacToeTurn.x
                turnLabel.text = x
            }
            else if(currentTurn == TicTacToeTurn.x){
                sender.setTitle(x, for: .normal)
                currentTurn = TicTacToeTurn.o
                turnLabel.text = o
            }
            sender.isEnabled = false
        }
    }
    func victory(_ s :String) -> Bool
        {
            // Horizontal Victory
            if thisSymbol(r1c1, s) && thisSymbol(r1c2, s) && thisSymbol(r1c3, s)
            {
                return true
            }
            if thisSymbol(r2c1, s) && thisSymbol(r2c2, s) && thisSymbol(r2c3, s)
            {
                return true
            }
            if thisSymbol(r3c1, s) && thisSymbol(r3c2, s) && thisSymbol(r3c3, s)
            {
                return true
            }
            
            // Vertical Victory
            if thisSymbol(r1c1, s) && thisSymbol(r2c1, s) && thisSymbol(r3c1, s)
            {
                return true
            }
            if thisSymbol(r1c2, s) && thisSymbol(r2c2, s) && thisSymbol(r3c2, s)
            {
                return true
            }
            if thisSymbol(r1c3, s) && thisSymbol(r2c3, s) && thisSymbol(r3c3, s)
            {
                return true
            }
            
            // Diagonal Victory
            if thisSymbol(r1c1, s) && thisSymbol(r2c2, s) && thisSymbol(r3c3, s)
            {
                return true
            }
            if thisSymbol(r1c3, s) && thisSymbol(r2c2, s) && thisSymbol(r3c1, s)
            {
                return true
            }
            
            return false
        }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    
    
}
