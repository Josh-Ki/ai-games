//
//  SudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
//MARK: This View Controller instantiates a board and allows a user to input numbers into the squares.
import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Firebase

var sudokuEasyWins = 0
var sudokuHardWins = 0
var sudokuMedWins = 0
class SudokuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    
    var selectedDifficulty: String?
    @IBOutlet weak var collectionView: UICollectionView!
    var sudokuArray: [[Int]] = []
    var partialArray: [[Int]] = []
    var maxCellsToFill : Int = 0
    let database = Firestore.firestore()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
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
    
    private func writeUserData(wins: Int, difficulty: String, userID: String) {
        let docRef = database.document("/users/\(userID)/sudoku/difficulty/\(difficulty)/wins")
        
        docRef.setData(["wins" : wins])
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    let itemsPerRow: CGFloat = 9
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    func verify() -> Bool {

        
        // Check that all rows contain distinct values between 1 and 9
        for row in 0..<9 {
            var seen = Set<Int>()
            for col in 0..<9 {
                let value = partialArray[row][col]
                if value < 1 || value > 9 || seen.contains(value) {
                    return false
                }
                seen.insert(value)
            }
        }
        
        // Check that all columns contain distinct values between 1 and 9
        for col in 0..<9 {
            var seen = Set<Int>()
            for row in 0..<9 {
                let value = partialArray[row][col]
                if value < 1 || value > 9 || seen.contains(value) {
                    return false
                }
                seen.insert(value)
            }
        }
        
        // Check that all 3x3 subgrids contain distinct values between 1 and 9
        for i in 0..<3 {
            for j in 0..<3 {
                var seen = Set<Int>()
                for row in i*3..<i*3+3 {
                    for col in j*3..<j*3+3 {
                        let value = partialArray[row][col]
                        if value < 1 || value > 9 || seen.contains(value) {
                            return false
                        }
                        seen.insert(value)
                    }
                }
            }
        }
        
        // If all checks pass, the board is valid
        
        if selectedDifficulty! == "Easy" {
            sudokuEasyWins += 1
            writeUserData(wins: sudokuEasyWins, difficulty: selectedDifficulty!, userID: userID)
        }
        else if selectedDifficulty! == "Med" {
            sudokuMedWins += 1
            writeUserData(wins: sudokuMedWins, difficulty: selectedDifficulty!, userID: userID)
        }
        else if selectedDifficulty! == "Hard" {
            sudokuHardWins += 1
            writeUserData(wins: sudokuHardWins, difficulty: selectedDifficulty!, userID: userID)
        }

        return true
    }

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
        if verify() {
            let alert = UIAlertController(title: "Solved", message: "You have solved the Sudoku!", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.restart()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(restartAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            // Verify failed, show error colors
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
    }

    func restart() {
        // Reset partialArray to all 0s and randomize initial values
        partialArray = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        for row in 0..<9 {
            for col in 0..<9 {
                if Int.random(in: 1...100) <= maxCellsToFill {
                    partialArray[row][col] = sudokuArray[row][col]
                }
            }
        }
        collectionView.reloadData()
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
