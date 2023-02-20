//
//  FourInARow.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

class FourInARow : GenericBoardGame {

    // game finishes with a winner
    override func done() {
        // if player X wins
        for y1 in 0...14 { // check for horizontal
            for x1 in 0...11 {
                let yx = y1 * 15 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+1].text == "X") && (self.gameboard[yx+2].text == "X") && (self.gameboard[yx+3].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 0...11 { // check for vertical
            for x1 in 0...14 {
                let yx = y1 * 15 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+15].text == "X") && (self.gameboard[yx+30].text == "X") && (self.gameboard[yx+45].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 0...11 { // check for diagonal
            for x1 in 0...11 {
                let yx = y1 * 15 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx+16].text == "X") && (self.gameboard[yx+32].text == "X") && (self.gameboard[yx+48].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        for y1 in 3...14 { // check for another diagonal
            for x1 in 0...11 {
                let yx = y1 * 15 + x1
                if ((self.gameboard[yx].text == "X") && (self.gameboard[yx-14].text == "X") && (self.gameboard[yx-28].text == "X") && (self.gameboard[yx-42].text == "X")) {
                    self.winner = "X"
                    return
                }
            }
        }
        
        // if player O wins
        for y2 in 0...14 { // check for horizontal
            for x2 in 0...11 {
                let yx = y2 * 15 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+1].text == "O") && (self.gameboard[yx+2].text == "O") && (self.gameboard[yx+3].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 0...11 { // check for vertical
            for x2 in 0...14 {
                let yx = y2 * 15 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+15].text == "O") && (self.gameboard[yx+30].text == "O") && (self.gameboard[yx+45].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 0...11 { // check for diagonal
            for x2 in 0...11 {
                let yx = y2 * 15 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx+16].text == "O") && (self.gameboard[yx+32].text == "O") && (self.gameboard[yx+48].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
        for y2 in 3...14 { // check for another diagonal
            for x2 in 0...11 {
                let yx = y2 * 15 + x2
                if ((self.gameboard[yx].text == "O") && (self.gameboard[yx-14].text == "O") && (self.gameboard[yx-28].text == "O") && (self.gameboard[yx-42].text == "O")) {
                    self.winner = "O"
                    return
                }
            }
        }
    }
    
    override func draw() -> Bool {
        if (self.moves < 4) {
            return false
        }
        
        // check for horizontal
        for y in 0...14 {
            for x in 0...11 {
                let yx = y * 15 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+1].text != "O") && (self.gameboard[yx+2].text != "O") && (self.gameboard[yx+3].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+1].text != "X") && (self.gameboard[yx+2].text != "X") && (self.gameboard[yx+3].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for vertical
        for y in 0...11 {
            for x in 0...14 {
                let yx = y * 15 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+15].text != "O") && (self.gameboard[yx+30].text != "O") && (self.gameboard[yx+45].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+15].text != "X") && (self.gameboard[yx+30].text != "X") && (self.gameboard[yx+45].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for diagonal
        for y in 0...11 {
            for x in 0...11 {
                let yx = y * 15 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx+16].text != "O") && (self.gameboard[yx+32].text != "O") && (self.gameboard[yx+48].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx+16].text != "X") && (self.gameboard[yx+32].text != "X") && (self.gameboard[yx+48].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        // check for another diagonal
        for y in 3...14 {
            for x in 0...11 {
                let yx = y * 15 + x
                if (self.gameboard[yx].text == "X") { // check for player X's pieces
                    if ((self.gameboard[yx-14].text != "O") && (self.gameboard[yx-28].text != "O") && (self.gameboard[yx-42].text != "O")) {
                        return false
                    }
                }
                if (self.gameboard[yx].text == "O") { // check for player O's pieces
                    if ((self.gameboard[yx-14].text != "X") && (self.gameboard[yx-28].text != "X") && (self.gameboard[yx-42].text != "X")) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
}
