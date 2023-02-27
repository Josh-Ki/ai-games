//
//  Board.swift
//  AI Games
//
//  Created by Joshua Ki on 2/21/23.
//

//MARK: Declared functions
import Foundation
import UIKit

var board = [[BoardItem]]()

func resetBoard() {
    board = (0...5).map { row in
        (0...6).map { column in
            let indexPath = IndexPath(item: column, section: row)
            return BoardItem(indexPath: indexPath, tile: Tile.Empty)
        }
    }
}


func getBoardItem(_ indexPath: IndexPath) -> BoardItem
{
    return board[indexPath.section][indexPath.item]
}

func getLowestEmpty(_ column: Int) -> BoardItem? {
    return (0...5).reversed()
        .compactMap { board[$0][column].emptyTile() ? board[$0][column] : nil }
        .first
}




func updateBoard(_ boardItem: BoardItem)
{
    if let indexPath = boardItem.indexPath
    {
        board[indexPath.section][indexPath.item] = boardItem
    }
}

func boardIsFull() -> Bool {
    for row in board {
        if row.contains(where: { $0.emptyTile() }) {
            return false
        }
    }
    return true
}


func victory()  -> Bool
{
    return horizontalVictory() || verticalVictory() || diagonalVictory()
}

func diagonalVictory() -> Bool {
    for column in 0..<board.count {
        for moveUp in [true, false] {
            for reverseRows in [true, false] {
                if checkDiagonalColumn(column, moveUp, reverseRows) {
                    return true
                }
            }
        }
    }
    return false
}


func checkDiagonalColumn(_ columnToCheck: Int, _ moveUp: Bool, _ reverseRows: Bool) -> Bool {
    let boardRows = reverseRows ? board.reversed() : board
    var movingColumn = columnToCheck
    var consecutive = 0
    
    for row in boardRows {
        guard movingColumn >= 0, movingColumn < row.count else { continue }
        if row[movingColumn].tile == currentTurnTile() {
            consecutive += 1
            if consecutive >= 4 { return true }
        } else {
            consecutive = 0
        }
        movingColumn += moveUp ? 1 : -1
    }
    
    return false
}


func verticalVictory() -> Bool {
    return (0..<board.count).contains {
        checkVerticalColumn($0)
    }
}


func checkVerticalColumn(_ columnToCheck: Int) -> Bool {
    var consecutive = 0
    for row in board where (0..<row.count).contains(columnToCheck) {
        if row[columnToCheck].tile == currentTurnTile() {
            consecutive += 1
            if consecutive >= 4 {
                return true
            }
        } else {
            consecutive = 0
        }
    }
    return false
}

func horizontalVictory() -> Bool {
    return board.contains { row in
        var consecutive = 0
        return row.contains {
            if $0.tile == currentTurnTile() {
                consecutive += 1
                if consecutive >= 4 {
                    return true
                }
            } else {
                consecutive = 0
            }
            return false
        }
    }
}

