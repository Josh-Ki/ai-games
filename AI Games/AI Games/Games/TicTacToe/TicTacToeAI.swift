//
//  TicTacToeMinimax.swift
//  AI Games
//
//  Created by Tony Ngok on 01/03/2023.
//

import Foundation

// easy AI: random move
func tttRandomMove(gameState: TicTocToeGameState) -> Int {
    if let r = gameState.legalMoves.randomElement() {
        return r
    }
    return -1
}

// medium AI: actively block line containing 2 X's
func tttMedium(gameState: TicTocToeGameState) -> Int {
    // https://www.programiz.com/swift-programming/sets
    var opt: Set<Int> = [] // list of return places
    
    for i in 0...2 {
        if ((gameState.gameboard[i*3] == "X") && (gameState.gameboard[i*3+1] == "X") && (gameState.gameboard[i*3+2] == "")) {
            opt.insert(i*3+2)
        } else if ((gameState.gameboard[i*3] == "X") && (gameState.gameboard[i*3+1] == "") && (gameState.gameboard[i*3+2] == "X")) {
            opt.insert(i*3+1)
        } else if ((gameState.gameboard[i*3] == "") && (gameState.gameboard[i*3+1] == "X") && (gameState.gameboard[i*3+2] == "X")) {
            opt.insert(i*3)
        }
        
        if ((gameState.gameboard[i] == "X") && (gameState.gameboard[i+3] == "X") && (gameState.gameboard[i+6] == "")) {
            opt.insert(i+6)
        } else if ((gameState.gameboard[i] == "X") && (gameState.gameboard[i+3] == "") && (gameState.gameboard[i+6] == "X")) {
            opt.insert(i+3)
        } else if ((gameState.gameboard[i] == "") && (gameState.gameboard[i+3] == "X") && (gameState.gameboard[i+6] == "X")) {
            opt.insert(i)
        }
    }
    
    if ((gameState.gameboard[0] == "X") && (gameState.gameboard[4] == "X") && (gameState.gameboard[8] == "")) {
        opt.insert(8)
    } else if ((gameState.gameboard[0] == "X") && (gameState.gameboard[4] == "") && (gameState.gameboard[8] == "X")) {
        opt.insert(4)
    } else if ((gameState.gameboard[0] == "") && (gameState.gameboard[4] == "X") && (gameState.gameboard[8] == "X")) {
        opt.insert(0)
    }
    
    if ((gameState.gameboard[2] == "X") && (gameState.gameboard[4] == "X") && (gameState.gameboard[6] == "")) {
        opt.insert(6)
    } else if ((gameState.gameboard[2] == "X") && (gameState.gameboard[4] == "") && (gameState.gameboard[6] == "X")) {
        opt.insert(4)
    } else if ((gameState.gameboard[2] == "") && (gameState.gameboard[4] == "X") && (gameState.gameboard[6] == "X")) {
        opt.insert(2)
    }
    
    if (opt.count == 1) {
        return opt.first ?? -1
    } else if (!opt.isEmpty) {
        return opt.randomElement() ?? -1
    }
    return tttRandomMove(gameState: gameState)
}

// minimax algorithm with alpha-beta pruning (invincible)
// a: MAX agent’s best option on path to root, initialised to infinitely small at root
// b: MIN agent’s best option on path to root, initialised to infinity at root
private func minimax(gameState: TicTocToeGameState, maxAgent: Bool, a: Int, b: Int) -> Int {
    // https://stackoverflow.com/questions/24451959/mutate-function-parameters-in-swift
    var a = a
    var b = b
    
    if (gameState.state > -2) {
        return gameState.state
    }
    
    if (maxAgent) {
        var v = Int.min
        for i in gameState.legalMoves {
            let successor = gameState.move(pos: i)
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

// https://freecontent.manning.com/classic-computer-science-problems-in-swift-tic-tac-toe/
func tttMinimaxBestMove(gameState: TicTocToeGameState) -> Int {
    var v = Int.min
    var bests: [Int] = []
    
    for i in gameState.legalMoves {
        // AI minimises man's utility score
        let eval = minimax(gameState: gameState.move(pos: i), maxAgent: false, a: Int.min, b: Int.max)
        
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
