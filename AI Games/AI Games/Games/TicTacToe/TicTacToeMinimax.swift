//
//  TicTacToeMinimax.swift
//  AI Games
//
//  Created by Tony Ngok on 01/03/2023.
//

import Foundation

func minimax(gameState: TicTocToeGameState, maxAgent: Bool) -> Int {
    if (gameState.state > -2) {
        return gameState.state
    }
    
    if (maxAgent) {
        var v = Int.min
        for i in gameState.legalMoves {
            let successor = gameState.move(pos: i)
            v = max(v, minimax(gameState: successor, maxAgent: false))
        }
        return v
    } else {
        var v = Int.max
        for i in gameState.legalMoves {
            let successor = gameState.move(pos: i)
            v = min(v, minimax(gameState: successor, maxAgent: true))
        }
        return v
    }
}

// https://freecontent.manning.com/classic-computer-science-problems-in-swift-tic-tac-toe/
func minimaxBestMove(gameState: TicTocToeGameState) -> Int {
    var v = Int.min
    var best = -1
    
    for i in gameState.legalMoves {
        // AI minimises man's utility score
        let eval = minimax(gameState: gameState.move(pos: i), maxAgent: false)
        
        if eval > v {
            v = eval
            best = i
        }
    }
    
    return best
}
