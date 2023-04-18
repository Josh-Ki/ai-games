//
//  GomokuGameState.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import Foundation

struct GomokuGameState {
    
    let gameboard: [String] // 10x10 gameboard (100 positions)
    let me: String
    let you: String
    var legalMoves: [Int] = []
    var heuristics: (Int, Int) = (0, 0) // «my» & «your» heuristic scores
    var state: Int = -2 // standardised states: win (1), draw (0), lose (-1) & incomplete (-2)
    var winSeq: [Int] = []
    
    init(gameboard: [String], isBlack: Bool) {
        self.gameboard = gameboard
        
        if (isBlack) { // black plays first
            self.me = "B"
            self.you = "W"
        } else {
            self.me = "W"
            self.you = "B"
        }
        
        self.legalMoves = getLegalMoves()
        self.heuristics = (heurScore(gameboard: self.gameboard, piece: self.me), heurScore(gameboard: self.gameboard, piece: self.you))
        self.state = getState()
        if ((self.state == -1) || (self.state == 1)) {
            // https://www.marcosantadev.com/arrayslice-in-swift/
            self.winSeq = getWinSeq() // winning sequence
        }
    }
    
    private func getLegalMoves() -> [Int] {
        return gameboard.indices.filter {
            gameboard[$0] == ""
        }
    }
    
    // return winning sequence (streak of 5)
    private func getWinSeq() -> [Int] {
        // check horizontally
        for y in 0...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+1] == me) && (gameboard[pos+2] == me) && (gameboard[pos+3] == me) && (gameboard[pos+4] == me)) {
                    return [pos, pos+1, pos+2, pos+3, pos+4]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+1] == you) && (gameboard[pos+2] == you) && (gameboard[pos+3] == you) && (gameboard[pos+4] == you)) {
                    return [pos, pos+1, pos+2, pos+3, pos+4]
                }
            }
        }
        
        // check vertically
        for y in 0...5 {
            for x in 0...9 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+10] == me) && (gameboard[pos+20] == me) && (gameboard[pos+30] == me) && (gameboard[pos+40] == me)) {
                    return [pos, pos+10, pos+20, pos+30, pos+40]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+10] == you) && (gameboard[pos+20] == you) && (gameboard[pos+30] == you) && (gameboard[pos+40] == you)) {
                    return [pos, pos+10, pos+20, pos+30, pos+40]
                }
            }
        }
        
        // check diagonally
        for y in 0...5 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+11] == me) && (gameboard[pos+22] == me) && (gameboard[pos+33] == me) && (gameboard[pos+44] == me)) {
                    return [pos, pos+11, pos+22, pos+33, pos+44]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+11] == you) && (gameboard[pos+22] == you) && (gameboard[pos+33] == you) && (gameboard[pos+44] == you)) {
                    return [pos, pos+11, pos+22, pos+33, pos+44]
                }
            }
        }
        
        // check reverse diagonally
        for y in 4...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos-9] == me) && (gameboard[pos-18] == me) && (gameboard[pos-27] == me) && (gameboard[pos-36] == me)) {
                    return [pos, pos-9, pos-18, pos-27, pos-36]
                }
                if ((gameboard[pos] == you) && (gameboard[pos-9] == you) && (gameboard[pos-18] == you) && (gameboard[pos-27] == you) && (gameboard[pos-36] == you)) {
                    return [pos, pos-9, pos-18, pos-27, pos-36]
                }
            }
        }
        
        return []
    }
    
    private func getState() -> Int {
        if (self.heuristics.0 >= winScore) {
            return 1
        } else if (self.heuristics.1 >= winScore) {
            return -1
        } else if (legalMoves.isEmpty) {
            return 0 // draw if no legal moves left
        }
        
        return -2
    }
    
    func move(pos: Int) -> GomokuGameState {
        var newGameboard = gameboard
        newGameboard[pos] = me
        let nextBlack = me == "B" ? false : true
        return GomokuGameState(gameboard: newGameboard, isBlack: nextBlack)
    }
    
}
