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
    var state: Int = 20000
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
        
        let res = winLose()
        self.state = getState(wl: res[0])
        if ((self.state == -10000) || (self.state == 10000)) {
            // https://www.marcosantadev.com/arrayslice-in-swift/
            self.winSeq = Array(res[1...5]) // winning sequence
        }
    }
    
    private func getLegalMoves() -> [Int] {
        return gameboard.indices.filter {
            gameboard[$0] == ""
        }
    }
    
    private func calcPos(y: Int, x: Int) -> Int {
        return y*10+x
    }
    
    // return array containing utility score (first number) & winning sequence (other 5 numbers)
    private func winLose() -> [Int] {
        // check horizontally
        for y in 0...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+1] == me) && (gameboard[pos+2] == me) && (gameboard[pos+3] == me) && (gameboard[pos+4] == me)) {
                    return [10000, pos, pos+1, pos+2, pos+3, pos+4]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+1] == you) && (gameboard[pos+2] == you) && (gameboard[pos+3] == you) && (gameboard[pos+4] == you)) {
                    return [-10000, pos, pos+1, pos+2, pos+3, pos+4]
                }
            }
        }
        
        // check vertically
        for y in 0...5 {
            for x in 0...9 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+10] == me) && (gameboard[pos+20] == me) && (gameboard[pos+30] == me) && (gameboard[pos+40] == me)) {
                    return [10000, pos, pos+10, pos+20, pos+30, pos+40]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+10] == you) && (gameboard[pos+20] == you) && (gameboard[pos+30] == you) && (gameboard[pos+40] == you)) {
                    return [-10000, pos, pos+10, pos+20, pos+30, pos+40]
                }
            }
        }
        
        // check diagonally
        for y in 0...5 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+11] == me) && (gameboard[pos+22] == me) && (gameboard[pos+33] == me) && (gameboard[pos+44] == me)) {
                    return [10000, pos, pos+11, pos+22, pos+33, pos+44]
                }
                if ((gameboard[pos] == you) && (gameboard[pos+11] == you) && (gameboard[pos+22] == you) && (gameboard[pos+33] == you) && (gameboard[pos+44] == you)) {
                    return [-10000, pos, pos+11, pos+22, pos+33, pos+44]
                }
            }
        }
        
        // check reverse diagonally
        for y in 4...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos-9] == me) && (gameboard[pos-18] == me) && (gameboard[pos-27] == me) && (gameboard[pos-36] == me)) {
                    return [10000, pos, pos-9, pos-18, pos-27, pos-36]
                }
                if ((gameboard[pos] == you) && (gameboard[pos-9] == you) && (gameboard[pos-18] == you) && (gameboard[pos-27] == you) && (gameboard[pos-36] == you)) {
                    return [-10000, pos, pos-9, pos-18, pos-27, pos-36]
                }
            }
        }
        
        return [0]
    }
    
    private func isDraw() -> Bool {
        // game should end after at least 9 total moves from both players
        if (legalMoves.count > 91) {
            return false
        }

        // check horizontally
        for y in 0...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if (gameboard[pos] == me) {
                    if ((gameboard[pos+1] != you) && (gameboard[pos+2] != you) && (gameboard[pos+3] != you) && (gameboard[pos+4] != you)) {
                        return false
                    }
                }
            }
        }
        
        // check vertically
        for y in 0...5 {
            for x in 0...9 {
                let pos = calcPos(y: y, x: x)
                if (gameboard[pos] == me) {
                    if ((gameboard[pos+10] != you) && (gameboard[pos+20] != you) && (gameboard[pos+30] != you) && (gameboard[pos+40] != you)) {
                        return false
                    }
                }
            }
        }
        
        // check diagonally
        for y in 0...5 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if (gameboard[pos] == me) {
                    if ((gameboard[pos+11] != you) && (gameboard[pos+22] != you) && (gameboard[pos+33] != you) && (gameboard[pos+44] != you)) {
                        return false
                    }
                }
            }
        }
        
        // check reverse diagonally
        for y in 4...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if (gameboard[pos] == me) {
                    if ((gameboard[pos-9] != you) && (gameboard[pos-18] != you) && (gameboard[pos-27] != you) && (gameboard[pos-36] != you)) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    private func getState(wl: Int) -> Int {
        if (wl != 0) {
            return wl
        }
        
        if ((wl == 0) && (legalMoves.isEmpty)) {
            return 0
        }
        if (isDraw()) {
            return 0
        }
        
        return 20000 // incomplete game state
    }
    
    func move(pos: Int) -> GomokuGameState {
        var newGameboard = gameboard
        newGameboard[pos] = me
        let nextBlack = me == "B" ? false : true
        return GomokuGameState(gameboard: newGameboard, isBlack: nextBlack)
    }
    
}
