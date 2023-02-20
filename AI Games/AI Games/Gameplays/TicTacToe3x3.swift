//
//  TicTacToeState.swift
//  AI Games
//
//  Created by Tony Ngok on 12/02/2023.
//

import Foundation

class TicTacToe3x3 : GenericBoardGame {
    
    // game finishes with a winner
    override func done() {
        // if player X wins
        for i1 in 0...2 { // check for horizontal
            if ((self.gameboard[i1*3].text == "X") && (self.gameboard[i1*3+1].text == "X") && (self.gameboard[i1*3+2].text == "X")) {
                self.winner = "X"
                return
            }
        }
        for j1 in 0...2 { // check for vertical
            if ((self.gameboard[j1].text == "X") && (self.gameboard[j1+3].text == "X") && (self.gameboard[j1+6].text == "X")) {
                self.winner = "X"
                return
            }
        }
        if ((self.gameboard[2].text == "X") && (self.gameboard[4].text == "X") && (self.gameboard[6].text == "X")) { // check for diagonal
            self.winner = "X"
            return
        }
        if ((self.gameboard[0].text == "X") && (self.gameboard[4].text == "X") && (self.gameboard[8].text == "X")) { // check for another diagonal
            self.winner = "X"
            return
        }
        
        // if player O wins
        for i2 in 0...2 { // check for horizontal
            if ((self.gameboard[i2*3].text == "O") && (self.gameboard[i2*3+1].text == "O") && (self.gameboard[i2*3+2].text == "O")) {
                self.winner = "O"
                return
            }
        }
        for j2 in 0...2 { // check for vertical
            if ((self.gameboard[j2].text == "O") && (self.gameboard[j2+3].text == "O") && (self.gameboard[j2+6].text == "O")) {
                self.winner = "O"
                return
            }
        }
        if ((self.gameboard[2].text == "O") && (self.gameboard[4].text == "O") && (self.gameboard[6].text == "O")) { // check for diagonal
            self.winner = "O"
            return
        }
        if ((self.gameboard[0].text == "O") && (self.gameboard[4].text == "O") && (self.gameboard[8].text == "O")) { // check for another diagonal
            self.winner = "O"
            return
        }
    }
    
    override func draw() -> Bool {
        if (self.moves < 9) {
            return false
        }

        if (self.winner != "") {
            return false
        }
        
        return true
    }
    
}
