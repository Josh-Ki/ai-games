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
    let legalMoves = gameState.legalMoves
    
    if ((depth == 0) || (gameState.state > -2)) {
        return gameState.heuristics.1-gameState.heuristics.0
    }
    
    // https://github.com/malikusha/Gomoku/blob/master/agent.py
    if (maxAgent) {
        var v = Int.min
        for i in legalMoves {
            gameState.move(pos: i)
            v = max(v, minimax(gameState: gameState, depth: depth-1, maxAgent: false, a: a, b: b))
            a = max(a, v)
            gameState.backMove(pos: i)
            if (a >= b) {
                return v
            }
        }
        return v
    } else {
        var v = Int.max
        for i in legalMoves {
            gameState.move(pos: i)
            v = min(v, minimax(gameState: gameState, depth: depth-1, maxAgent: true, a: a, b: b))
            b = min(b, v)
            gameState.backMove(pos: i)
            if (a >= b) {
                return v
            }
        }
        return v
    }
}

func gomokuMinimaxBestMove(gameState: GomokuGameState, depth: Int) -> Int {
    var v = Int.min
    var bests: [Int] = []
    let legalMoves = gameState.legalMoves
    
    for i in legalMoves {
        // AI minimises man's utility score
        gameState.move(pos: i)
        let eval = minimax(gameState: gameState, depth: depth, maxAgent: false, a: Int.min, b: Int.max)
//        print("at=\(i); move=\(s.you); heur=\(s.heuristics); d=\(s.heuristics.0-s.heuristics.1)") // debug
        
        if (eval > v) {
            v = eval
            bests.removeAll()
            bests.append(i)
        } else if (eval == v) {
            bests.append(i)
        }
        gameState.backMove(pos: i)
    }
    
    // https://stackoverflow.com/questions/24003191/pick-a-random-element-from-an-array
    if let r = bests.randomElement() { // pick one among multiple best moves
        return r
    }
    return -1
}
