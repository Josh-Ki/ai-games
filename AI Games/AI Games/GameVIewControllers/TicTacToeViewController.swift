//
//  TicTacToeViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//

import UIKit

class TicTacToeViewController: UIViewController {

    var squares: [UILabel] = []
    var currentPlayer = "X"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gridSize: CGFloat = 3.0
        let squareSize: CGFloat = min(view.bounds.width, view.bounds.height) / gridSize
        let gridWidth = squareSize * gridSize
        let gridHeight = squareSize * gridSize
        let gridX = (view.bounds.width - gridWidth) / 2
        let gridY = (view.bounds.height - gridHeight) / 2

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
    }

    @objc func squareTapped(_ sender: UITapGestureRecognizer) {
        let square = sender.view as! UILabel
        print("tapped")
        
        if square.text == nil {
            
    
            UIView.transition(with: square, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                square.text = self.currentPlayer
            }, completion: nil)
            
            switchTurns()
        }
    }
    
    func switchTurns() {
        currentPlayer = currentPlayer == "X" ? "O" : "X"
    }
    
}
