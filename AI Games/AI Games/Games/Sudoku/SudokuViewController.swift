//
//  SudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
//MARK: This View Controller instantiates a board and allows a user to input numbers into the squares.
import UIKit

class SudokuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var selectedDifficulty: String?
    @IBOutlet weak var collectionView: UICollectionView!
    var sudokuArray: [[Int]] = []
    var partialArray: [[Int]] = []
    var maxCellsToFill : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch selectedDifficulty {
        case "Easy":
            maxCellsToFill = 30
        case "Medium":
            maxCellsToFill = 50
        case "Hard":
            maxCellsToFill = 64
        default:
            maxCellsToFill = 30
        }
        (sudokuArray, partialArray) = generateSudokuBoard()

        
    }

    let itemsPerRow: CGFloat = 9
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        // Find all empty cells
        var emptyCells: [(Int, Int)] = []
        for row in 0..<9 {
            for col in 0..<9 {
                if partialArray[row][col] == 0 {
                    emptyCells.append((row, col))
                }
            }
        }

        // Select a random empty cell and fill in the correct number
        if let randomEmptyCell = emptyCells.randomElement() {
            let row = randomEmptyCell.0
            let col = randomEmptyCell.1
            partialArray[row][col] = sudokuArray[row][col]
            collectionView.reloadItems(at: [IndexPath(row: row * 9 + col, section: 0)])
        }

    }
    
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        for row in 0..<9 {
            for col in 0..<9 {
                let indexPath = IndexPath(row: row * 9 + col, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? SudokuCell else {
                    continue
                }
                let userValue = partialArray[row][col]
                let correctValue = sudokuArray[row][col]
                if userValue != correctValue {
                    // User input is incorrect
                    cell.label.backgroundColor = UIColor.red
                } else {
                    // User input is correct
                    cell.label.backgroundColor = UIColor.green
                }
            }
        }

    }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow

            return CGSize(width: widthPerItem, height: widthPerItem)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    
 
    @IBAction func change(_ textField: UITextField) {
        let row = textField.tag / 9
        let col = textField.tag % 9
        if let text = textField.text, let value = Int(text), value >= 1, value <= 9 {
            partialArray[row][col] = value
            print(partialArray[row][col])
        } else {
            partialArray[row][col] = 0
            textField.text = ""
        }
    }
    


        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
            let row = indexPath.row / 9
            let col = indexPath.row % 9
            print(partialArray)
            let value = partialArray[row][col]
            cell.label.text = "\(value == 0 ? "" : "\(value)")"
            cell.label.textAlignment = .center // center the text
            cell.label.tag = indexPath.row
            cell.label.isUserInteractionEnabled = value == 0
            return cell
        }

        func textFieldDidChange(_ textField: UITextField) {

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
        var cellsToFill = maxCellsToFill
        while cellsToFill > 0 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            if partialBoard[row][col] != 0 {
                partialBoard[row][col] = 0
                cellsToFill -= 1
            }
        }

        return (board, partialBoard)
    }



}
