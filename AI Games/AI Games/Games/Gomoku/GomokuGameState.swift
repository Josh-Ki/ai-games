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
        self.state = getState()
    }
    
    private func getLegalMoves() -> [Int] {
        return gameboard.indices.filter {
            gameboard[$0] == ""
        }
    }
    
    private func calcPos(y: Int, x: Int) -> Int {
        return y*10+x
    }
    
    private func winLose() -> Int {
        // check horizontally
        for y in 0...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+1] == me) && (gameboard[pos+2] == me) && (gameboard[pos+3] == me) && (gameboard[pos+4] == me)) {
                    return 10000
                }
                if ((gameboard[pos] == you) && (gameboard[pos+1] == you) && (gameboard[pos+2] == you) && (gameboard[pos+3] == you) && (gameboard[pos+4] == you)) {
                    return -10000
                }
            }
        }
        
        // check vertically
        for y in 0...5 {
            for x in 0...9 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+10] == me) && (gameboard[pos+20] == me) && (gameboard[pos+30] == me) && (gameboard[pos+40] == me)) {
                    return 10000
                }
                if ((gameboard[pos] == you) && (gameboard[pos+10] == you) && (gameboard[pos+20] == you) && (gameboard[pos+30] == you) && (gameboard[pos+40] == you)) {
                    return -10000
                }
            }
        }
        
        // check diagonally
        for y in 0...5 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos+11] == me) && (gameboard[pos+22] == me) && (gameboard[pos+33] == me) && (gameboard[pos+44] == me)) {
                    return 10000
                }
                if ((gameboard[pos] == you) && (gameboard[pos+11] == you) && (gameboard[pos+22] == you) && (gameboard[pos+33] == you) && (gameboard[pos+44] == you)) {
                    return -10000
                }
            }
        }
        
        // check reverse diagonally
        for y in 4...9 {
            for x in 0...5 {
                let pos = calcPos(y: y, x: x)
                if ((gameboard[pos] == me) && (gameboard[pos-9] == me) && (gameboard[pos-18] == me) && (gameboard[pos-27] == me) && (gameboard[pos-36] == me)) {
                    return 10000
                }
                if ((gameboard[pos] == you) && (gameboard[po-9] == you) && (gameboard[pos-18] == you) && (gameboard[pos-27] == you) && (gameboard[pos-36] == you)) {
                    return -10000
                }
            }
        }
        
        return 0
    }
    
    private func getState() -> Int {
        // TODO: implement game state detection
        
        return 20000 // incomplete game state
    }
    
}
