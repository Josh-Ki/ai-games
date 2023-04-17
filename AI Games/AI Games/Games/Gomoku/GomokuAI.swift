//
//  GomokuAI.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import Foundation

// easy AI: random move
func gomokuRandomMove(gameState: GomokuGameState) -> Int {
    if let r = gameState.legalMoves.randomElement() {
        return r
    }
    return -1
}

// minimax algorithm with alpha-beta pruning
// a: MAX agent’s best option on path to root, initialised to infinitely small at root
// b: MIN agent’s best option on path to root, initialised to infinity at root
private func minimax(gameState: GomokuGameState, depth: Int, maxAgent: Bool, a: Int, b: Int) -> Int {
    // https://stackoverflow.com/questions/24451959/mutate-function-parameters-in-swift
    var a = a
    var b = b
    var gameboard = gameState.gameboard
    
    if (depth == 0) {
        return heurScore(gameboard: gameboard, me: gameState.me, turn: maxAgent ? gameState.me : gameState.you)
    }
    
    if (maxAgent) {
        var v = Int.min
        for i in gameState.legalMoves {
            gameboard[i] = gameState.me
            v = max(v, minimax(gameState: successor, maxAgent: false, a: a, b: b))
            a = max(a, v)
            if (a >= b) {
                return v
            }
        }
        return v
    } else {
        var v = Int.max
        for i in gameState.legalMoves {
            let successor = gameState.move(pos: i)
            v = min(v, minimax(gameState: successor, maxAgent: true, a: a, b: b))
            b = min(b, v)
            if (a >= b) {
                return v
            }
        }
        return v
    }
}


