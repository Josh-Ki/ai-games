//
//  GenericBoardGame.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation
import UIKit

// https://freecontent.manning.com/classic-computer-science-problems-in-swift-tic-tac-toe/
class GenericBoardGame {
    
    var gameboard: [UILabel]
    var turn: String
    var moves: Int = 0
    var winner: String = ""
    
    init(gameboard: [UILabel] = [], turn: String = "") {
        self.gameboard = gameboard
        self.turn = turn
    }
    
    func update(gameboard: [UILabel]) {
        if (self.turn == "X") {
            self.gameboard = gameboard
        }
            
        self.moves += 1
        self.done()
        
        if (self.winner != "") {
            print("Winner: \(self.winner)")
            return
        }
        if (self.draw()) {
            print("The game is a draw")
            return
        }
        
        // switch turn
        if (self.turn == "X") {
            self.turn = "O"
        } else {
            self.turn = "X"
        }
    }
    
    func done() {} // abstract function to be overriden
    
    func draw() -> Bool { // abstract function to be overriden
        return false
    }
    
    // get a list of legal moves (for AI)
    func legalPositions() -> [Int] {
        return self.gameboard.indices.filter {
            self.gameboard[$0].text == nil
        }
    }
    
    func AIPlay() -> [UILabel] {
        let pos = randomAI(legalPositions: self.legalPositions())
        self.gameboard[pos].text = "O"
        return self.gameboard
    }
    
}
