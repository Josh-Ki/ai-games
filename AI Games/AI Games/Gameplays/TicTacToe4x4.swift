//
//  TicTacToe4x4.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

class TicTacToe4x4 : GenericBoardGame {
    
    // game finishes with a winner
    override func done() {
        // if player X wins
        for i1 in 0...3 { // check for horizontal
            if ((self.gameboard[i1*4].text == "X") && (self.gameboard[i1*4+1].text == "X") && (self.gameboard[i1*4+2].text == "X") && (self.gameboard[i1*4+3].text == "X")) {
                self.winner = "X"
                return
            }
        }
        for j1 in 0...3 { // check for vertical
            if ((self.gameboard[j1].text == "X") && (self.gameboard[j1+4].text == "X") && (self.gameboard[j1+8].text == "X") && (self.gameboard[j1+12].text == "X")) {
                self.winner = "X"
                return
            }
        }
        if ((self.gameboard[3].text == "X") && (self.gameboard[6].text == "X") && (self.gameboard[9].text == "X") && (self.gameboard[12].text == "X")) { // check for diagonal
            self.winner = "X"
            return
        }
        if ((self.gameboard[0].text == "X") && (self.gameboard[5].text == "X") && (self.gameboard[10].text == "X") && (self.gameboard[15].text == "X")) { // check for another diagonal
            self.winner = "X"
            return
        }
        
        // if player O wins
        for i2 in 0...2 { // check for horizontal
            if ((self.gameboard[i2*4].text == "O") && (self.gameboard[i2*4+1].text == "O") && (self.gameboard[i2*4+2].text == "O") && (self.gameboard[i2*4+3].text == "O")) {
                self.winner = "O"
                return
            }
        }
        for j2 in 0...2 { // check for vertical
            if ((self.gameboard[j2].text == "O") && (self.gameboard[j2+4].text == "O") && (self.gameboard[j2+8].text == "O") && (self.gameboard[j2+12].text == "O")) {
                self.winner = "O"
                return
            }
        }
        if ((self.gameboard[3].text == "O") && (self.gameboard[6].text == "O") && (self.gameboard[9].text == "O") && (self.gameboard[12].text == "O")) { // check for diagonal
            self.winner = "O"
            return
        }
        if ((self.gameboard[0].text == "O") && (self.gameboard[5].text == "O") && (self.gameboard[10].text == "O") && (self.gameboard[15].text == "O")) { // check for another diagonal
            self.winner = "O"
            return
        }
    }
    
    override func draw() -> Bool {
        if (self.moves < 16) {
            return false
        }
        
        if (self.winner != "") {
            return false
        }
        
        return true
    }
    
}
