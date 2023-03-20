//
//  TicTacToeViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
//MARK: This View controller creates the tic tac toe board and allows for users to switch between x and o in order to play.

import UIKit
//import FirebaseFirestore
//import FirebaseCore
//import FirebaseAuth
//import Firebase

var ticTacToeWins = 0

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
//    let userID = Auth.auth().currentUser!.uid
//    let database = Firestore.firestore()
    
//    func writeUserData(wins: Int, userID: String) {
//        let docRef = database.document("/users/\(userID)/tictactoe/wins")
//        docRef.setData(["wins" : wins])
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    var board = [UIButton]()
    var firstTurn = TicTacToeTurn.x
    var currentTurn = TicTacToeTurn.x
    
    var o = "O"
    var x = "X"
    var oScore = 0
    var xScore = 0
    var userMoves = 0
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (addToBoard(sender)) {
            if victory(x) {
                xScore += 1
                resultAlert(title: "X WINS")
                ticTacToeWins += 1
//                writeUserData(wins: ticTacToeWins, userID: userID)
            } else if (boardIsFull()) {
                resultAlert(title: "Draw")
            } else {
                AIPlays()
            }
        }
    }
    
    func AIPlays() {
        let move = minimaxBestMove(gameState: toGameState())
        switch move {
        case 0:
            r1c1.setTitle(o, for: .normal)
            break
        case 1:
            r1c2.setTitle(o, for: .normal)
            break
        case 2:
            r1c3.setTitle(o, for: .normal)
            break
        case 3:
            r2c1.setTitle(o, for: .normal)
            break
        case 4:
            r2c2.setTitle(o, for: .normal)
            break
        case 5:
            r2c3.setTitle(o, for: .normal)
            break
        case 6:
            r3c1.setTitle(o, for: .normal)
            break
        case 7:
            r3c2.setTitle(o, for: .normal)
            break
        case 8:
            r3c3.setTitle(o, for: .normal)
            break
        default:
            break
        }
        
        if victory(o) {
            oScore += 1
            resultAlert(title: "O Wins")
        } else if (boardIsFull()) {
            resultAlert(title: "Draw")
        }
        
        currentTurn = TicTacToeTurn.x
        turnLabel.text = x
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
    
    func boardIsFull() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }

    func resultAlert(title:String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        userMoves = 0
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
        if (firstTurn == TicTacToeTurn.o) {
            AIPlays()
        }
    }

    func addToBoard(_ sender: UIButton) -> Bool {
        if (sender.title(for: .normal) == nil) {
            if (currentTurn == TicTacToeTurn.x) {
                sender.setTitle(x, for: .normal)
                userMoves += 1
                print("man move \(userMoves)")
                currentTurn = TicTacToeTurn.o
                turnLabel.text = o
            }
            sender.isEnabled = false
            return true
        }
        return false
    }
    
    func victory(_ s :String) -> Bool {
        // Horizontal Victory
        if thisSymbol(r1c1, s) && thisSymbol(r1c2, s) && thisSymbol(r1c3, s) {
            return true
        }
        if thisSymbol(r2c1, s) && thisSymbol(r2c2, s) && thisSymbol(r2c3, s) {
            return true
        }
        if thisSymbol(r3c1, s) && thisSymbol(r3c2, s) && thisSymbol(r3c3, s) {
            return true
        }
        
        // Vertical Victory
        if thisSymbol(r1c1, s) && thisSymbol(r2c1, s) && thisSymbol(r3c1, s) {
            return true
        }
        if thisSymbol(r1c2, s) && thisSymbol(r2c2, s) && thisSymbol(r3c2, s) {
            return true
        }
        if thisSymbol(r1c3, s) && thisSymbol(r2c3, s) && thisSymbol(r3c3, s) {
            return true
        }
        
        // Diagonal Victory
        if thisSymbol(r1c1, s) && thisSymbol(r2c2, s) && thisSymbol(r3c3, s) {
            return true
        }
        if thisSymbol(r1c3, s) && thisSymbol(r2c2, s) && thisSymbol(r3c1, s) {
            return true
        }
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func toGameState() -> TicTocToeGameState {
        var gameboard = [r1c1.title(for: .normal) ?? ""]
        gameboard.append(r1c2.title(for: .normal) ?? "")
        gameboard.append(r1c3.title(for: .normal) ?? "")
        gameboard.append(r2c1.title(for: .normal) ?? "")
        gameboard.append(r2c2.title(for: .normal) ?? "")
        gameboard.append(r2c3.title(for: .normal) ?? "")
        gameboard.append(r3c1.title(for: .normal) ?? "")
        gameboard.append(r3c2.title(for: .normal) ?? "")
        gameboard.append(r3c3.title(for: .normal) ?? "")
        
        return TicTocToeGameState(gameboard: gameboard, turn: currentTurn == TicTacToeTurn.x ? "X" : "O")
    }
    
}
