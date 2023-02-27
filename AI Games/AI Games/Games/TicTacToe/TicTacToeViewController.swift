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
    }
    
    var firstTurn = TicTacToeTurn.x
    var currentTurn = TicTacToeTurn.x
    
    var o = "O"
    var x = "X"
    @IBAction func buttonTapped(_ sender: UIButton) {
        addToBoard(sender)
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
        }
    }
    
    
    
}
