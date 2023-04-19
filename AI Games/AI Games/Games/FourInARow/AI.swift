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
    
    // Check for winning move
    for move in moves {
        var boardItem = getLowestEmpty(move.column)!
        boardItem.tile = currentTurnTile()
        updateBoard(boardItem)
        if isWinningMove(boardItem) {
            boardItem.tile = .Empty
            updateBoard(boardItem)
            return [move]
        }
        boardItem.tile = .Empty
        updateBoard(boardItem)
    }
    
    // Calculate score for each move and store it in a tuple
    var scoredMoves = [(Move, Int)]()
    for move in moves {
        var boardItem = getLowestEmpty(move.column)!
        boardItem.tile = currentTurnTile()
        updateBoard(boardItem)
        let score = evaluateBoard()
        boardItem.tile = .Empty
        updateBoard(boardItem)
        scoredMoves.append((move, score))
    }
    
    // Sort the moves based on their score
    scoredMoves.sort { $0.1 > $1.1 }
    
    // Return the sorted moves
    return scoredMoves.map { $0.0 }
}



func isWinningMove(_ boardItem: BoardItem) -> Bool {
    let directions: [(rowStep: Int, colStep: Int)] = [(0, 1), (1, 0), (1, 1), (-1, 1)]
    for direction in directions {
        var count = 0
        var row = boardItem.row
        var col = boardItem.column
        while row >= 0 && row < board.count && col >= 0 && col < board[row].count {
            if board[row][col].tile == boardItem.tile {
                count += 1
            } else {
                break
            }
            if count == 4 {
                return true
            }
            row += direction.rowStep
            col += direction.colStep
        }
    }
    return false
}



func evaluateBoard() -> Int {
    let aiTile: Tile = .Red
    let humanTile: Tile = .Yellow
    var score = 0
    
    // Score center column
    let centerColumn = board.map { $0[3] }
    let centerCount = centerColumn.filter { $0.tile == aiTile }.count
    score += centerCount * 6
    
    // Score rows, columns, and diagonals
    let directions: [(rowStep: Int, colStep: Int)] = [(0, 1), (1, 0), (1, 1), (-1, 1)]
    for direction in directions {
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                var startRow = row
                var startCol = col
                var window: [Tile] = []
                for _ in 0..<4 {
                    if startRow < 0 || startRow >= board.count || startCol < 0 || startCol >= board[row].count {
                        break
                    }
                    window.append(board[startRow][startCol].tile)
                    startRow += direction.rowStep
                    startCol += direction.colStep
                }
                if window.count == 4 {
                    score += evaluateWindow(window: window, aiTile: aiTile, humanTile: humanTile)
                }
            }
        }
    }
    
    return score
}

func evaluateWindow(window: [Tile], aiTile: Tile, humanTile: Tile) -> Int {
    let aiCount = window.filter { $0 == aiTile }.count
    let humanCount = window.filter { $0 == humanTile }.count
    if humanCount == 4 {
        return -100000
    } else if aiCount == 4 {
        return 100000
    } else if humanCount == 3 && aiCount == 0 {
        return -1000
    } else if aiCount == 3 && humanCount == 0 {
        return 1000
    } else if humanCount == 2 && aiCount == 0 {
        // Check for diagonal win
        if window[0] == humanTile && window[1] == humanTile && window[2] == Tile.Empty && window[3] == humanTile {
            
            return -100
        } else if window[0] == humanTile && window[1] == Tile.Empty && window[2] == humanTile && window[3] == humanTile {
            
            return -100
        }
        return -10
    } else if aiCount == 2 && humanCount == 0 {
        // Check for diagonal win
        if window[0] == aiTile && window[1] == aiTile && window[2] == Tile.Empty && window[3] == aiTile {
            
            return 100
        } else if window[0] == aiTile && window[1] == Tile.Empty && window[2] == aiTile && window[3] == aiTile {
        
            return 100
        }
        return 10
    } else {
        return 0
    }
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

