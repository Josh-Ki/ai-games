//
//  FiveInARow.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

//class FiveInARow : GenericBoardGame {
//    
//    init(whoStarts: Int) {
//        super.init(gameboardSize: 19, whoStarts: whoStarts)
//    }
//    
//    
//    // game finishes with a winner
//    override func done() -> Bool {
//        // if man wins
//        for y1 in 0...18 { // check for horizontal
//            for x1 in 0...14 {
//                if ((self.gameboard[y1][x1] == 1) && (self.gameboard[y1][x1+1] == 1) && (self.gameboard[y1][x1+1] == 1) && (self.gameboard[y1][x1+3] == 1) && (self.gameboard[y1][x1+4] == 1)) {
//                    self.winner = 1
//                    return true
//                }
//            }
//        }
//        for y1 in 0...14 { // check for vertical
//            for x1 in 0...18 {
//                if ((self.gameboard[y1][x1] == 1) && (self.gameboard[y1+1][x1] == 1) && (self.gameboard[y1+2][x1] == 1) && (self.gameboard[y1+3][x1] == 1) && (self.gameboard[y1+4][x1] == 1)) {
//                    self.winner = 1
//                    return true
//                }
//            }
//        }
//        for y1 in 0...14 { // check for diagonal
//            for x1 in 0...14 {
//                if ((self.gameboard[y1][x1] == 1) && (self.gameboard[y1+1][x1+1] == 1) && (self.gameboard[y1+2][x1+2] == 1) && (self.gameboard[y1+3][x1+3] == 1) && (self.gameboard[y1+4][x1+4] == 1)) {
//                    self.winner = 1
//                    return true
//                }
//            }
//        }
//        for y1 in 4...18 { // check for another diagonal
//            for x1 in 0...14 {
//                if ((self.gameboard[y1][x1] == 1) && (self.gameboard[y1-1][x1+1] == 1) && (self.gameboard[y1-2][x1+2] == 1) && (self.gameboard[y1-3][x1+3] == 1) && (self.gameboard[y1-4][x1+4] == 1)) {
//                    self.winner = 1
//                    return true
//                }
//            }
//        }
//        
//        // if AI wins
//        for y2 in 0...18 { // check for horizontal
//            for x2 in 0...14 {
//                if ((self.gameboard[y2][x2] == 2) && (self.gameboard[y2][x2+1] == 2) && (self.gameboard[y2][x2+1] == 2) && (self.gameboard[y2][x2+3] == 2) && (self.gameboard[y2][x2+4] == 2)) {
//                    self.winner = 2
//                    return true
//                }
//            }
//        }
//        for y2 in 0...14 { // check for vertical
//            for x2 in 0...18 {
//                if ((self.gameboard[y2][x2] == 2) && (self.gameboard[y2+1][x2] == 2) && (self.gameboard[y2+2][x2] == 2) && (self.gameboard[y2+3][x2] == 2) && (self.gameboard[y2+4][x2] == 2)) {
//                    self.winner = 2
//                    return true
//                }
//            }
//        }
//        for y2 in 0...14 { // check for diagonal
//            for x2 in 0...14 {
//                if ((self.gameboard[y2][x2] == 2) && (self.gameboard[y2+1][x2+1] == 2) && (self.gameboard[y2+2][x2+2] == 2) && (self.gameboard[y2+3][x2+3] == 2) && (self.gameboard[y2+4][x2+4] == 2)) {
//                    self.winner = 2
//                    return true
//                }
//            }
//        }
//        for y2 in 4...18 { // check for another diagonal
//            for x2 in 0...14 {
//                if ((self.gameboard[y2][y2] == 2) && (self.gameboard[y2-1][x2+1] == 2) && (self.gameboard[y2-2][x2+2] == 2) && (self.gameboard[x2-3][x2+3] == 2) && (self.gameboard[y2-4][x2+4] == 2)) {
//                    self.winner = 2
//                    return true
//                }
//            }
//        }
//        
//        return false
//    }
//    
//    
//    override func draw() -> Bool {
//        if (self.moves < 5) {
//            return false
//        }
//        
//        // check for horizontal
//        for y in 0...18 {
//            for x in 0...14 {
//                if (self.gameboard[y][x] == 1) { // check for man's pieces
//                    if ((self.gameboard[y][x+1] != 2) && (self.gameboard[y][x+2] != 2) && (self.gameboard[y][x+3] != 2) && (self.gameboard[y][x+4] != 2)) {
//                        return false
//                    }
//                }
//                if (self.gameboard[y][x] == 2) { // check for AI's pieces
//                    if ((self.gameboard[y][x+1] != 1) && (self.gameboard[y][x+2] != 1) && (self.gameboard[y][x+3] != 1) && (self.gameboard[y][x+3] != 1)) {
//                        return false
//                    }
//                }
//            }
//        }
//        
//        // check for vertical
//        for y in 0...14 {
//            for x in 0...18 {
//                if (self.gameboard[y][x] == 1) { // check for man's pieces
//                    if ((self.gameboard[y+1][x] != 2) && (self.gameboard[y+2][x] != 2) && (self.gameboard[y+3][x] != 2) && (self.gameboard[y+4][x] != 2)) {
//                        return false
//                    }
//                }
//                if (self.gameboard[y][x] == 2) { // check for AI's pieces
//                    if ((self.gameboard[y+1][x] != 1) && (self.gameboard[y+2][x] != 1) && (self.gameboard[y+3][x] != 1) && (self.gameboard[y+4][x] != 1)) {
//                        return false
//                    }
//                }
//            }
//        }
//        
//        // check for diagonal
//        for y in 0...14 {
//            for x in 0...14 {
//                if (self.gameboard[y][x] == 1) { // check for man's pieces
//                    if ((self.gameboard[y+1][x+1] != 2) && (self.gameboard[y+2][x+2] != 2) && (self.gameboard[y+3][x+3] != 2) && (self.gameboard[y+4][x+4] != 2)) {
//                        return false
//                    }
//                }
//                if (self.gameboard[y][x] == 2) { // check for AI's pieces
//                    if ((self.gameboard[y+1][x+1] != 1) && (self.gameboard[y+2][x+2] != 1) && (self.gameboard[y+3][x+3] != 1) && (self.gameboard[y+4][x+4] != 1)) {
//                        return false
//                    }
//                }
//            }
//        }
//        
//        // check for another diagonal
//        for y in 4...18 {
//            for x in 0...14 {
//                if (self.gameboard[y][x] == 1) { // check for man's pieces
//                    if ((self.gameboard[y-1][x+1] != 2) && (self.gameboard[y-2][x+2] != 2) && (self.gameboard[y-3][x+3] != 2) && (self.gameboard[y-4][x+4] != 2)) {
//                        return false
//                    }
//                }
//                if (self.gameboard[y][x] == 2) { // check for AI's pieces
//                    if ((self.gameboard[y-1][x+1] != 1) && (self.gameboard[y-2][x+2] != 1) && (self.gameboard[y-3][x+3] != 1) && (self.gameboard[y-4][x+4] != 1)) {
//                        return false
//                    }
//                }
//            }
//        }
//        
//        return true
//    }
//    
//}
