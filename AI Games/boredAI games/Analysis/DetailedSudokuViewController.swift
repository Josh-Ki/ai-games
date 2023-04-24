//
//  DetailedSudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit

class DetailedSudokuViewController: UIViewController {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var mistakesLabel: UILabel!

    
    var gameNumber : Int?
    var hints : Int?
    var mistakes : Int?
    
    var sudokuArray: [[Int]] = []
    var startingArray:[[Int]] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)

        gameLabel.text = "Game \(gameNumber!) Analysis"
        hintsLabel.text = "Hints Used: \(hints!)"
        mistakesLabel.text = "Mistakes Made: \(mistakes!)"
        print(sudokuArray)
        let sudokuBoardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SudokuViewController") as! SudokuViewController
        sudokuBoardViewController.sudoku.startingArray = sudokuArray
        sudokuBoardViewController.sudoku.partialArray = sudokuArray
        sudokuBoardViewController.toGenerate = false
        // Add the Sudoku board view controller as a child view controller of the GameSelectionViewController
       
        addChild(sudokuBoardViewController)
        sudokuBoardViewController.view.frame = imageView.bounds
        imageView.addSubview(sudokuBoardViewController.view)
        sudokuBoardViewController.didMove(toParent: self)
        
        
        sudokuBoardViewController.checkButton.isHidden = true
        sudokuBoardViewController.hintButton.isHidden = true
        sudokuBoardViewController.label1.isHidden = true
        sudokuBoardViewController.label2.isHidden = true
        sudokuBoardViewController.label3.isHidden = true
        sudokuBoardViewController.label4.isHidden = true
        sudokuBoardViewController.label5.isHidden = true
        sudokuBoardViewController.label6.isHidden = true
        sudokuBoardViewController.label7.isHidden = true
        sudokuBoardViewController.label8.isHidden = true
        sudokuBoardViewController.label9.isHidden = true
        sudokuBoardViewController.infoButton.isHidden = true
        sudokuBoardViewController.deleteButton.isHidden = true
        
    }
    
    
    @IBAction func replayButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(
            withIdentifier: "SudokuViewController") as! SudokuViewController
        vc.toGenerate = false
        vc.sudoku.partialArray = sudokuArray
        vc.sudoku.startingArray = sudokuArray
        vc.sudoku.sudokuArray = generateCompleteSudokuBoard(from: sudokuArray)
        

        self.navigationController?.pushViewController(vc, animated: true)
}
    func generateCompleteSudokuBoard(from partialBoard: [[Int]]) -> [[Int]] {
        // Create an empty 9x9 Sudoku board
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        // Copy the partially filled board to the empty board
        for row in 0..<9 {
            for col in 0..<9 {
                board[row][col] = partialBoard[row][col]
            }
        }
        
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
            
            // If the current cell is already filled, move on to the next cell
            if board[row][col] != 0 {
                return fillBoard(nextRow, nextCol)
            }
            
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
        _ = fillBoard(0, 0)
        
        return board
    }

}
                       
        
