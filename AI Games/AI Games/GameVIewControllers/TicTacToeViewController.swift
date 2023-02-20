//
//  TicTacToeViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//

import UIKit

class TicTacToeViewController: UIViewController {

    var squares: [UILabel] = []
//    var currentPlayer = "X"
    var gameplay: TicTacToe3x3 = TicTacToe3x3()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gridSize: CGFloat = 3.0
        let squareSize: CGFloat = min(view.bounds.width, view.bounds.height) / gridSize
        let gridWidth = squareSize * gridSize
        let gridHeight = squareSize * gridSize
        let gridX = (view.bounds.width - gridWidth) / 2
        let gridY = (view.bounds.height - gridHeight) / 2
        let AILevel: Int = 0

        squares = Array(repeating: UILabel(), count: Int(gridSize * gridSize))
        
        for row in 0..<Int(gridSize) {
            for col in 0..<Int(gridSize) {
                let square = UILabel(frame: CGRect(x: gridX + CGFloat(col) * squareSize,
                                                  y: gridY + CGFloat(row) * squareSize,
                                                  width: squareSize,
                                                  height: squareSize))
                square.backgroundColor = UIColor.lightGray
                square.textAlignment = .center
                square.font = UIFont.systemFont(ofSize: squareSize / 2)
                square.layer.borderWidth = 2.0
                square.layer.borderColor = UIColor.black.cgColor
                square.isUserInteractionEnabled = true
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(squareTapped(_:)))
                square.addGestureRecognizer(tapGestureRecognizer)
                
                squares[row * Int(gridSize) + col] = square
                
                view.addSubview(square)
            }
        }
        
        gameplay = TicTacToe3x3(gameboard: squares, turn: "X")
        if (gameplay.turn == "O") {
            squares = gameplay.AIPlays(level: AILevel) // AI plays O
            gameplay.update()
        }
    }

    @objc func squareTapped(_ sender: UITapGestureRecognizer) {
        let square = sender.view as! UILabel
        print("tapped")
        
        if (gameplay.winner == "") {
            if square.text == nil {
                UIView.transition(with: square, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    square.text = self.gameplay.turn
                }, completion: nil)
                
                gameplay.manPlays(gameboard: squares)
                
                // if man doesn't win or draw, let AI play
                if ((gameplay.winner == "") && (!gameplay.draw())) {
                    squares = gameplay.AIPlays(level: 0)
                    gameplay.update()
                }
                
                if (gameplay.winner != "") {
                    let dialogMessage = UIAlertController(title: "Game over", message: "Winner: " + gameplay.winner, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                } else if (gameplay.draw()) {
                    let dialogMessage = UIAlertController(title: "Game over", message: "The game ends in a draw.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                }
            }
        }
    }
    
//    func switchTurns() {
//        currentPlayer = currentPlayer == "X" ? "O" : "X"
//    }
    
}
