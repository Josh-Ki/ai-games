//
//  GomokuGameState.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import Foundation

class GomokuGameState {
    
    var gameboard: [String] = [] // 10x10 gameboard (100 positions)
    var ai: String = "" // AI
    var man: String = "" // man
    var turn: String = ""
    var legalMoves: [Int] = []
    var heuristics: (Int, Int) = (0, 0) // «my» & «your» heuristic scores
    var state: Int = -2 // standardised states: win (1), draw (0), lose (-1) & incomplete (-2)
    var winSeq: [Int] = []
    
    init(gameboard: [String], isBlack: Bool) {
        self.gameboard = gameboard
        
        if (isBlack) { // black plays AI
            self.ai = "B"
            self.man = "W"
        } else {
            self.ai = "W"
            self.man = "B"
        }
        self.turn = self.ai
        
        self.refresh()
    }
    
    // called after making or undoing one move (for AI analysis)
    private func refresh() {
        self.legalMoves = getLegalMoves()
        self.heuristics = (heurScore(gameboard: self.gameboard, piece: self.man), heurScore(gameboard: self.gameboard, piece: self.ai))
        self.state = getState()
        if ((self.state == -1) || (self.state == 1)) {
            self.winSeq = getWinSeq() // winning sequence
        } else {
            self.winSeq = []
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
                if ((gameboard[pos] == ai) && (gameboard[pos+1] == ai) && (gameboard[pos+2] == ai) && (gameboard[pos+3] == ai) && (gameboard[pos+4] == ai)) {
                    return [pos, pos+1, pos+2, pos+3, pos+4]
                }
                if ((gameboard[pos] == man) && (gameboard[pos+1] == man) && (gameboard[pos+2] == man) && (gameboard[pos+3] == man) && (gameboard[pos+4] == man)) {
                    return [pos, pos+1, pos+2, pos+3, pos+4]
                }
            }
        }
        
        // check vertically
        for y in 0...5 {
            for x in 0...9 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == ai) && (gameboard[pos+10] == ai) && (gameboard[pos+20] == ai) && (gameboard[pos+30] == ai) && (gameboard[pos+40] == ai)) {
                    return [pos, pos+10, pos+20, pos+30, pos+40]
                }
                if ((gameboard[pos] == man) && (gameboard[pos+10] == man) && (gameboard[pos+20] == man) && (gameboard[pos+30] == man) && (gameboard[pos+40] == man)) {
                    return [pos, pos+10, pos+20, pos+30, pos+40]
                }
            }
        }
        
        // check diagonally
        for y in 0...5 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == ai) && (gameboard[pos+11] == ai) && (gameboard[pos+22] == ai) && (gameboard[pos+33] == ai) && (gameboard[pos+44] == ai)) {
                    return [pos, pos+11, pos+22, pos+33, pos+44]
                }
                if ((gameboard[pos] == man) && (gameboard[pos+11] == man) && (gameboard[pos+22] == man) && (gameboard[pos+33] == man) && (gameboard[pos+44] == man)) {
                    return [pos, pos+11, pos+22, pos+33, pos+44]
                }
            }
        }
        
        // check reverse diagonally
        for y in 4...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == ai) && (gameboard[pos-9] == ai) && (gameboard[pos-18] == ai) && (gameboard[pos-27] == ai) && (gameboard[pos-36] == ai)) {
                    return [pos, pos-9, pos-18, pos-27, pos-36]
                }
                if ((gameboard[pos] == man) && (gameboard[pos-9] == man) && (gameboard[pos-18] == man) && (gameboard[pos-27] == man) && (gameboard[pos-36] == man)) {
                    return [pos, pos-9, pos-18, pos-27, pos-36]
                }
            }
        }
        
        return []
    }
    
    private func getState() -> Int {
        if (self.heuristics.0 >= winScore) {
            return -1
        } else if (self.heuristics.1 >= winScore) {
            return 1
        } else if (legalMoves.isEmpty) {
            return 0 // draw if no legal moves left
        }
        
        return -2
    }
    
    func move(pos: Int) {
        self.gameboard[pos] = self.turn
        self.turn = self.turn == self.ai ? self.man : self.ai
        self.refresh()
    }
    
    func backMove(pos: Int) {
        self.gameboard[pos] = ""
        self.turn = self.turn == self.ai ? self.man : self.ai
        self.refresh()
    }
    
}
