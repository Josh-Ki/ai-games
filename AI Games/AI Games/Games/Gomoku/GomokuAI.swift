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

// TODO: more Gomoku AIs (e.g., minimax with alpha-beta pruning)
