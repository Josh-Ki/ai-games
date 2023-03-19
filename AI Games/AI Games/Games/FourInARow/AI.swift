//
//  AI.swift
//  AI Games
//
//  Created by Joshua Ki on 3/19/23.
//

import Foundation
import UIKit

func generateAIMoves() -> [Move] {
    var moves = [Move]()
    for column in 0..<board[0].count {
        if let _ = getLowestEmpty(column) {
            moves.append(Move(column: column))
        }
    }
    
    // Order moves by their score
    moves.sort { move1, move2 in
        let column1 = move1.column
        guard var boardItem1 = getLowestEmpty(column1) else { return false }
        boardItem1.tile = currentTurnTile()
        updateBoard(boardItem1)
        let score1 = evaluateBoard()
        
        let column2 = move2.column
        guard var boardItem2 = getLowestEmpty(column2) else { return false }
        boardItem2.tile = currentTurnTile()
        updateBoard(boardItem2)
        let score2 = evaluateBoard()
        
        // Reset the board
        boardItem1.tile = .Empty
        updateBoard(boardItem1)
        
        boardItem2.tile = .Empty
        updateBoard(boardItem2)
        
        return score1 > score2
    }
    
    return moves
}

func evaluateBoard() -> Int {
    let aiTile: Tile = .Red
    let humanTile: Tile = .Yellow
    var score = 0
    
    // Score center column
    let centerArray = [board[0][3], board[1][3], board[2][3], board[3][3], board[4][3], board[5][3]]
    let centerCount = centerArray.filter { $0.tile == aiTile }.count
    score += centerCount * 6
    
    // Score Horizontal
    for row in 0..<board.count {
        let rowArray = [board[row][0], board[row][1], board[row][2], board[row][3], board[row][4], board[row][5], board[row][6]]
        for col in 0..<rowArray.count - 3 {
            let window = Array(rowArray[col...col + 3])
            score += evaluatewindow(window: window, aiTile: aiTile, humanTile: humanTile)
        }
    }
    
    // Score Vertical
    for col in 0..<board[0].count {
        let colArray = [board[0][col], board[1][col], board[2][col], board[3][col], board[4][col], board[5][col]]
        for row in 0..<colArray.count - 3 {
            let window = Array(colArray[row...row + 3])
            score += evaluatewindow(window: window, aiTile: aiTile, humanTile: humanTile)
        }
    }
    // Score positive diagonal
    for row in 0..<board.count - 3 {
        for col in 0..<board[row].count - 3 {
            let window = [board[row][col], board[row + 1][col + 1],
                          board[row + 2][col + 2], board[row + 3][col + 3]]
            score += evaluatewindow(window: window, aiTile: aiTile, humanTile: humanTile)
        }
    }
    
    // Score negative diagonal
    for row in 0..<board.count - 3 {
        for col in 0..<board[row].count - 3 {
            let window = [board[row + 3][col], board[row + 2][col + 1],
                          board[row + 1][col + 2], board[row][col + 3]]
            score += evaluatewindow(window: window, aiTile: aiTile, humanTile: humanTile)
        }
    }
    
    return score
}

func evaluatewindow(window: [BoardItem], aiTile: Tile, humanTile: Tile) -> Int {
    var score = 0
    let aiCount = window.filter { $0.tile == aiTile }.count
    let humanCount = window.filter { $0.tile == humanTile }.count
    let emptyCount = window.filter { $0.tile == .Empty }.count
    
    // Add these weights as constants or parameters
    let centerWeight = 3 // increase this value to prioritize center column more
    let edgeWeight = 2 // increase this value to prioritize edge rows more
    let diagonalWeight = 4 // increase this value to prioritize diagonal alignments more
    
    if aiCount == 4{
        score += 100000000
    } else if aiCount == 3 && emptyCount == 1 {
        score += 5000 * diagonalWeight // multiply by diagonal weight if window is diagonal
    } else if aiCount == 2 && emptyCount == 2 {
        score += 50 * centerWeight // multiply by center weight if window contains center column
    } else if aiCount == 1 && emptyCount == 3 {
        score += 5 * edgeWeight // multiply by edge weight if window contains edge row
    }
    
    // Add these lines to prioritize blocking human player's moves
    if humanCount == 3 && emptyCount == 1 {
        score -= 80 * diagonalWeight // increase this value and multiply by diagonal weight to prioritize blocking more
    } else if humanCount == 2 && emptyCount == 2 {
        score -= 40 * centerWeight // increase this value and multiply by center weight to prioritize blocking more
    }
    
    // Check for additional patterns
   let pattern1: [Tile] = [humanTile, aiTile, aiTile, humanTile]
   let pattern2: [Tile] = [humanTile, aiTile, humanTile, aiTile]
   let pattern3: [Tile] = [aiTile, aiTile, humanTile, humanTile]
   let pattern4: [Tile] = [humanTile, humanTile, aiTile, aiTile]
   
   if window.map({ $0.tile }) == pattern1 {
       score -= (200 + (centerWeight + edgeWeight) / 2) * (diagonalWeight + centerWeight) / 2
       // decrease this value and multiply by average of position weights
   } else if window.map({ $0.tile }) == pattern2 {
       score -= (150 + (centerWeight + edgeWeight) / 2) * (diagonalWeight + centerWeight) / 2
       // decrease this value and multiply by average of position weights
   } else if window.map({ $0.tile }) == pattern3 {
       score += (150 + (centerWeight + edgeWeight) / 2) * (diagonalWeight + centerWeight) / 2
       // increase this value and multiply by average of position weights
   } else if window.map({ $0.tile }) == pattern4 {
       score += (200 + (centerWeight + edgeWeight) / 2) * (diagonalWeight + centerWeight) / 2
       // increase this value and multiply by average of position weights
   }
    return score
}


func minimax(depth: Int, maxdepth: Int, bestmove: inout Move?, alpha: Int, beta: Int) -> Int {
    if depth == maxdepth || victory() || boardIsFull() {
        return evaluateBoard()
    }
    
    var bestScore = alpha
    let moves = generateAIMoves()
    
    for move in moves {
        let column = move.column
        guard var boardItem = getLowestEmpty(column) else { continue }
        
        boardItem.tile = currentTurnTile()
        updateBoard(boardItem)
        //toggleTurn(turnImage)
        
        let score = -minimax(depth: depth + 1, maxdepth: maxdepth, bestmove: &bestmove, alpha: -beta, beta: -bestScore)
        
        //toggleTurn(turnImage)
        boardItem.tile = .Empty
        updateBoard(boardItem)
        
        if score > bestScore {
            bestScore = score
            bestmove = move
            
            if bestScore >= beta {
                break
            }
        }
    }
    
    return bestScore
}

