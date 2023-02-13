//
//  TicTacToe4x4.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

class TicTacToe4x4 : GenericBoardGame {
    
    init(whoStarts: Int) {
        super.init(gameboardSize: 4, whoStarts: whoStarts)
    }
    
    
    // game finishes with a winner
    override func done() -> Bool {
        // if man wins
        for i1 in 0...3 { // check for horizontal
            if ((self.gameboard[i1][0] == 1) && (self.gameboard[i1][1] == 1) && (self.gameboard[i1][2] == 1) && (self.gameboard[i1][3] == 1)) {
                self.winner = 1
                return true
            }
        }
        for j1 in 0...3 { // check for vertical
            if ((self.gameboard[0][j1] == 1) && (self.gameboard[1][j1] == 1) && (self.gameboard[2][j1] == 1) && (self.gameboard[j1][3] == 1)) {
                self.winner = 1
                return true
            }
        }
        if ((self.gameboard[0][0] == 1) && (self.gameboard[1][1] == 1) && (self.gameboard[2][2] == 1) && (self.gameboard[3][3] == 1)) { // check for diagonal
            self.winner = 1
            return true
        }
        if ((self.gameboard[0][3] == 1) && (self.gameboard[1][2] == 1) && (self.gameboard[2][1] == 1) && (self.gameboard[3][0] == 1)) { // check for another diagonal
            self.winner = 1
            return true
        }
        
        // if AI wins
        for i2 in 0...3 { // check for horizontal
            if ((self.gameboard[i2][0] == 2) && (self.gameboard[i2][1] == 2) && (self.gameboard[i2][2] == 2) && (self.gameboard[i2][3] == 2)) {
                self.winner = 2
                return true
            }
        }
        for j2 in 0...3 { // check for vertical
            if ((self.gameboard[0][j2] == 2) && (self.gameboard[1][j2] == 2) && (self.gameboard[2][j2] == 2) && (self.gameboard[3][j2] == 2)) {
                self.winner = 2
                return true
            }
        }
        if ((self.gameboard[0][0] == 2) && (self.gameboard[1][1] == 2) && (self.gameboard[2][2] == 2) && (self.gameboard[3][3] == 2)) { // check for diagonal
            self.winner = 2
            return true
        }
        if ((self.gameboard[0][3] == 2) && (self.gameboard[1][2] == 2) && (self.gameboard[2][1] == 2) && (self.gameboard[3][0] == 2)) { // check for another diagonal
            self.winner = 2
            return true
        }
        
        return false
    }
    
    
    override func draw() -> Bool {
        if (self.moves < 16) {
            return false
        }
        
        if (self.done()) {
            return false
        }
        
        return true
    }
    
}
