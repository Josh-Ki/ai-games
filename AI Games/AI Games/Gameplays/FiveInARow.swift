//
//  FiveInARow.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

class FiveInARow : GenericBoardGame {

    // game finishes with a winner
    override func done() {
        // if player X wins
        for y1 in 0...18 { // check for horizontal
            for x1 in 0...14 {
                let yx = y1 * 19 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+1].text == "X") && (self.gameboard[yx+2].text == "X") && (self.gameboard[yx+3].text == "X") && (self.gameboard[yx+4].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 0...14 { // check for vertical
            for x1 in 0...18 {
                let yx = y1 * 19 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+19].text == "X") && (self.gameboard[yx+38].text == "X") && (self.gameboard[yx+57].text == "X") && (self.gameboard[yx+76].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 0...14 { // check for diagonal
            for x1 in 0...14 {
                let yx = y1 * 19 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+20].text == "X") && (self.gameboard[yx+40].text == "X") && (self.gameboard[yx+60].text == "X") && (self.gameboard[yx+80].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 4...18 { // check for another diagonal
            for x1 in 0...14 {
                let yx = y1 * 19 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx-18].text == "X") && (self.gameboard[yx-36].text == "X") && (self.gameboard[yx-54].text == "X") && (self.gameboard[yx-72].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        
        // if player O wins
        for y2 in 0...18 { // check for horizontal
            for x2 in 0...14 {
                let yx = y2 * 19 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+1].text == "O") && (self.gameboard[yx+2].text == "O") && (self.gameboard[yx+3].text == "O") && (self.gameboard[yx+4].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 0...14 { // check for vertical
            for x2 in 0...18 {
                let yx = y2 * 19 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+19].text == "O") && (self.gameboard[yx+38].text == "O") && (self.gameboard[yx+57].text == "O") && (self.gameboard[yx+76].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 0...14 { // check for diagonal
            for x2 in 0...14 {
                let yx = y2 * 19 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+20].text == "O") && (self.gameboard[yx+40].text == "O") && (self.gameboard[yx+60].text == "O") && (self.gameboard[yx+80].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 4...18 { // check for another diagonal
            for x2 in 0...14 {
                let yx = y2 * 19 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx-18].text == "O") && (self.gameboard[yx-36].text == "O") && (self.gameboard[yx-54].text == "O") && (self.gameboard[yx-72].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
    }
    
    override func draw() -> Bool {
        if (self.moves < 5) {
            return false
        }
        
        // check for horizontal
        for y in 0...18 {
            for x in 0...14 {
                let yx = y * 19 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+1].text != "O") && (self.gameboard[yx+2].text != "O") && (self.gameboard[yx+3].text != "O") && (self.gameboard[yx+4].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+1].text != "X") && (self.gameboard[yx+2].text != "X") && (self.gameboard[yx+3].text != "X") && (self.gameboard[yx+4].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for vertical
        for y in 0...14 {
            for x in 0...18 {
                let yx = y * 19 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+19].text != "O") && (self.gameboard[yx+38].text != "O") && (self.gameboard[yx+57].text != "O") && (self.gameboard[yx+76].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+19].text != "X") && (self.gameboard[yx+38].text != "X") && (self.gameboard[yx+57].text != "X") && (self.gameboard[yx+76].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for diagonal
        for y in 0...14 {
            for x in 0...14 {
                let yx = y * 19 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+20].text != "O") && (self.gameboard[yx+40].text != "O") && (self.gameboard[yx+60].text != "O") && (self.gameboard[yx+80].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+20].text != "X") && (self.gameboard[yx+40].text != "X") && (self.gameboard[yx+60].text != "X") && (self.gameboard[yx+80].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for another diagonal
        for y in 4...18 {
            for x in 0...14 {
                let yx = y * 19 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx-18].text != "O") && (self.gameboard[yx-36].text != "O") && (self.gameboard[yx-54].text != "O") && (self.gameboard[yx-72].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx-18].text != "X") && (self.gameboard[yx-36].text != "X") && (self.gameboard[yx-54].text != "X") && (self.gameboard[yx-72].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
}
