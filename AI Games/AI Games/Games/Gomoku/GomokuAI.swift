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
    
    if ((depth == 0) || (gameState.state > -2)) {
        if (maxAgent) {
            return gameState.heuristics.0-gameState.heuristics.1 // advantage relative to the opponent
        } else {
            return gameState.heuristics.1-gameState.heuristics.0
        }
        
    }
    
    if (maxAgent) {
        var v = Int.min
        for i in gameState.legalMoves {
            let successor = gameState.move(pos: i)
            v = max(v, minimax(gameState: successor, depth: depth-1, maxAgent: false, a: a, b: b))
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
            v = min(v, minimax(gameState: successor, depth: depth-1, maxAgent: true, a: a, b: b))
            b = min(b, v)
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
    
    for i in gameState.legalMoves {
        // AI minimises man's utility score
        let s = gameState.move(pos: i)
        let eval = minimax(gameState: s, depth: depth, maxAgent: false, a: Int.min, b: Int.max)
//        print("at=\(i); move=\(s.you); heur=\(s.heuristics); d=\(s.heuristics.0-s.heuristics.1)") // debug
        
        if (eval > v) {
            v = eval
            bests.removeAll()
            bests.append(i)
        } else if (eval == v) {
            bests.append(i)
        }
    }
    
    // https://stackoverflow.com/questions/24003191/pick-a-random-element-from-an-array
    if let r = bests.randomElement() { // pick one among multiple best moves
        return r
    }
    return -1
}
