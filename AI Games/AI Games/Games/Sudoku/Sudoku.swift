//
//  Sudoku.swift
//  AI Games
//
//  Created by Joshua Ki on 4/16/23.
//

import Foundation
import UIKit


struct Sudoku {
    var easyWins: Int = 0
    var medWins: Int = 0
    var hardWins: Int = 0
    var maxCellsToFill: Int = 0
    var hintsUsed: Int = 0
    var mistakesMade: Int = 0
    var sudokuArray: [[Int]] = []
    var partialArray: [[Int]] = []
    var startingArray: [[Int]] = []
    var mistakeCoordinates: [(Int,Int)] = []
}


extension SudokuViewController {
    
    func flashBoardRed() {
        for row in 0..<9 {
            for col in 0..<9 {
                let indexPath = IndexPath(row: row * 9 + col, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? SudokuCell else {
                    continue
                }
                cell.label.backgroundColor = UIColor.red
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            for row in 0..<9 {
                for col in 0..<9 {
                    let indexPath = IndexPath(row: row * 9 + col, section: 0)
                    guard let cell = self?.collectionView.cellForItem(at: indexPath) as? SudokuCell else {
                        continue
                    }
                    cell.label.backgroundColor = UIColor.white
                }
            }
        }
    }

    func turnCellsToWhite() {
        for row in 0..<9 {
            for col in 0..<9 {
                let indexPath = IndexPath(row: row * 9 + col, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? SudokuCell else {
                    continue
                }
                cell.label.backgroundColor = UIColor.white
            }
        }
    }
    
    func generateSudokuBoard() -> ([[Int]], [[Int]]) {
        // Create an empty 9x9 Sudoku board
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        // Define a function to check if a value is valid in a given position
        func isValid(_ value: Int, _ row: Int, _ col: Int) -> Bool {
            // Check if the value is already in the same row or column
            for i in 0..<9 {
                if board[row][i] == value || board[i][col] == value {
                    return false
                }
            }
            
            // Check if the value is already in the same 3x3 subgrid
            let subgridRow = (row / 3) * 3
            let subgridCol = (col / 3) * 3
            for i in subgridRow..<(subgridRow + 3) {
                for j in subgridCol..<(subgridCol + 3) {
                    if board[i][j] == value {
                        return false
                    }
                }
            }
            
            return true
        }
        
        // Define a function to fill the board recursively
        func fillBoard(_ row: Int, _ col: Int) -> Bool {
            // Check if we have filled all rows of the board
            if row == 9 {
                return true
            }
            
            // Calculate the next position to fill
            let nextCol = (col + 1) % 9
            let nextRow = nextCol == 0 ? row + 1 : row
            
            // Shuffle the numbers 1-9 to generate a random order
            var numbers = Array(1...9)
            numbers.shuffle()
            
            // Try each number in the shuffled order until we find a valid one
            for number in numbers {
                if isValid(number, row, col) {
                    // Place the valid number in the current position
                    board[row][col] = number
                    
                    // Recursively fill the rest of the board
                    if fillBoard(nextRow, nextCol) {
                        return true
                    }
                    
                    // If we couldn't fill the rest of the board, backtrack
                    board[row][col] = 0
                }
            }
            
            // If we couldn't find a valid number for this position, backtrack
            return false
        }
        
        // Fill the board starting from the top-left corner
        fillBoard(0, 0)
        
        // Create a copy of the board for partially filled board
        var partialBoard = board.map { $0.map { $0 } }
        
        
        // Randomly remove cells from the board to create a partially filled board
        var cellsToFill = sudoku.maxCellsToFill
        var cellsToBlank = 81 - cellsToFill
        
        while cellsToBlank > 0 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            if partialBoard[row][col] != 0 {
                partialBoard[row][col] = 0
                cellsToBlank -= 1
            }
        }
        sudoku.hintsUsed = 0
        return (board, partialBoard)
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: selectedIndexPath!) as! SudokuCell
        let row = selectedIndexPath!.row / 9
        let col = selectedIndexPath!.row % 9

        cell.label.delegate = self
        
        let labelText = label.text
        print(Int(labelText!)!)
        sudoku.partialArray[row][col] = Int(labelText!)!
                    if sudoku.partialArray[row][col] != sudoku.sudokuArray[row][col]{
                        print("ITS WrONG")
                        sudoku.mistakesMade += 1
                        sudoku.mistakeCoordinates.append((row,col))
                    }
        collectionView.reloadData()

        UIView.animate(withDuration: 0.2, animations: {
            label.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                label.transform = CGAffineTransform.identity
            })
        })
    }


}
