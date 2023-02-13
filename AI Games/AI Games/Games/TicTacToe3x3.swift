//
//  TicTacToeState.swift
//  AI Games
//
//  Created by Tony Ngok on 12/02/2023.
//

import Foundation

class TicTacToe3x3 : GenericBoardGame {
    
    init(whoStarts: Int) {
        super.init(gameboardSize: 3, whoStarts: whoStarts)
    }
    
    
    // game finishes with a winner
    override func done() -> Bool {
        // if man wins
        for i1 in 0...2 { // check for horizontal
            if ((self.gameboard[i1][0] == 1) && (self.gameboard[i1][1] == 1) && (self.gameboard[i1][2] == 1)) {
                self.winner = 1
                return true
            }
        }
        for j1 in 0...2 { // check for vertical
            if ((self.gameboard[0][j1] == 1) && (self.gameboard[1][j1] == 1) && (self.gameboard[2][j1] == 1)) {
                self.winner = 1
                return true
            }
        }
        if ((self.gameboard[0][0] == 1) && (self.gameboard[1][1] == 1) && (self.gameboard[2][2] == 1)) { // check for diagonal
            self.winner = 1
            return true
        }
        if ((self.gameboard[0][2] == 1) && (self.gameboard[1][1] == 1) && (self.gameboard[2][0] == 1)) { // check for another diagonal
            self.winner = 1
            return true
        }
        
        // if AI wins
        for i2 in 0...2 { // check for horizontal
            if ((self.gameboard[i2][0] == 2) && (self.gameboard[i2][1] == 2) && (self.gameboard[i2][2] == 2)) {
                self.winner = 2
                return true
            }
        }
        for j2 in 0...2 { // check for vertical
            if ((self.gameboard[0][j2] == 2) && (self.gameboard[1][j2] == 2) && (self.gameboard[2][j2] == 2)) {
                self.winner = 2
                return true
            }
        }
        if ((self.gameboard[0][0] == 2) && (self.gameboard[1][1] == 2) && (self.gameboard[2][2] == 2)) { // check for diagonal
            self.winner = 2
            return true
        }
        if ((self.gameboard[0][2] == 2) && (self.gameboard[1][1] == 2) && (self.gameboard[2][0] == 2)) { // check for another diagonal
            self.winner = 2
            return true
        }
        
        return false
    }
    
    
    override func draw() -> Bool {
        if (self.moves < 9) {
            return false
        }
        
        if (self.done()) {
            return false
        }
        
        return true
    }
    
}
