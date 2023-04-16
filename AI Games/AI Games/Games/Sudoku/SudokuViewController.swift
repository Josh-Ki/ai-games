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


class SudokuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var timer: UILabel!
    var time = Timer()
    var seconds = 0
    
    @IBOutlet weak var checkButton: UIButton!
    var grayedIndices: [Int] = []
    @IBOutlet weak var hintButton: UIButton!
    var sudoku = Sudoku()
    var selectedDifficulty: String?

    @IBOutlet weak var collectionView: UICollectionView!

    
    let database = Firestore.firestore()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Register for keyboard notifications
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        collectionView.backgroundColor = view.backgroundColor
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(checkButtonLongPressed(_:)))
            checkButton.addGestureRecognizer(longPressRecognizer)
        switch selectedDifficulty {
        case "Easy":
            sudoku.maxCellsToFill = 51
            getHighestWinsForDifficulty(difficulty: "Easy", userID: userID) { (highestWins) in
                if let highestWins = highestWins {
                    self.sudoku.easyWins = highestWins
                    print("Highest number of wins for easy: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for easy")
                }
            }
//            maxCellsToFill = 30
        case "Med":
            sudoku.maxCellsToFill = 31
            getHighestWinsForDifficulty(difficulty: "Med", userID: userID) { (highestWins) in
                if let highestWins = highestWins {
                    self.sudoku.medWins = highestWins
                    print("Highest number of wins for med: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for med")
                }
            }
        case "Hard":
            sudoku.maxCellsToFill = 17
            getHighestWinsForDifficulty(difficulty: "Hard", userID: userID) { (highestWins) in
                if let highestWins = highestWins {
                    self.sudoku.hardWins = highestWins
                    print("Highest number of wins for hard: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for med")
                }
            }
        default:
            sudoku.maxCellsToFill = 30
        }
        (sudoku.sudokuArray, sudoku.partialArray) = generateSudokuBoard()
        sudoku.startingArray = sudoku.partialArray
        // Call the function to calculate the average time for the current user and difficulty
//        calculateAverageTimeForUserAndDifficulty(userID: userID, difficulty: "Easy") { (averageTime) in
//            if let averageTime = averageTime {
//                // The average time was successfully calculated
//                print("The average time for user123 on hard difficulty is \(averageTime) seconds.")
//            } else {
//                // There was an error fetching the documents or there were no documents
//                print("Could not calculate the average time.")
//            }
//        }

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        
    }
    private func getHighestWinsForDifficulty(difficulty: String, userID: String, completion: @escaping (Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/sudoku/difficulty/\(difficulty)")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
            } else {
                var highestWins: Int?
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let wins = data["wins"] as! Int
                    
                    if highestWins == nil || wins > highestWins! {
                        highestWins = wins
                    }
                }
                
                completion(highestWins)
            }
        }
    }


    
    private func writeUserData(wins: Int, difficulty: String, userID: String, time: Int, board: [[Int]], hints: Int) {
        let collectionRef = database.collection("/users/\(userID)/sudoku/difficulty/\(difficulty)")
        let newDocRef = collectionRef.document()
        
        let winData = [
            "id": newDocRef.documentID,
            "wins": wins,
            "time": time,
            "board": board.flatMap { $0 },
            "hints": hints
        ] as [String : Any]
        
        newDocRef.setData(winData)
    }
    private func calculateAverageTimeForUserAndDifficulty(userID: String, difficulty: String, completion: @escaping (Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/sudoku/difficulty/\(difficulty)")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            var totalTime = 0
            var numDocuments = 0
            
            for document in querySnapshot!.documents {
                let time = document.data()["time"] as? Int ?? 0
                totalTime += time
                numDocuments += 1
            }
            
            if numDocuments > 0 {
                let averageTime = totalTime / numDocuments
                completion(averageTime)
            } else {
                completion(nil)
            }
        }
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
                let value = sudoku.partialArray[row][col]
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
                let value = sudoku.partialArray[row][col]
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
                        let value = sudoku.partialArray[row][col]
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
            sudoku.easyWins += 1
            time.invalidate()
            writeUserData(wins: sudoku.easyWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed)
        }
        else if selectedDifficulty! == "Med" {
            sudoku.medWins += 1
            time.invalidate()
            writeUserData(wins: sudoku.medWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed)
        }
        else if selectedDifficulty! == "Hard" {
            sudoku.hardWins += 1
            time.invalidate()
            writeUserData(wins: sudoku.hardWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed)
        }

        return true
    }
    
    func timeStringToSeconds(_ timeString: String) -> Int {
        let components = timeString.components(separatedBy: ":")
        guard components.count == 2,
            let minutes = Int(components[0]),
            let seconds = Int(components[1]) else {
                return 0
        }
        return minutes * 60 + seconds
    }

    @objc func updateTimer() {
            seconds += 1
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            
            // Update the timer label with the new time
            timer.text = String(format: "%d:%02d", minutes, remainingSeconds)
        }

    @IBAction func hintButtonTapped(_ sender: Any) {
        sudoku.hintsUsed += 1
        // Find all empty cells
        var emptyCells: [(Int, Int)] = []
        for row in 0..<9 {
            for col in 0..<9 {
                if sudoku.partialArray[row][col] == 0 {
                    emptyCells.append((row, col))
                }
            }
        }

        // Select a random empty cell and fill in the correct number
        if let randomEmptyCell = emptyCells.randomElement() {
            let row = randomEmptyCell.0
            let col = randomEmptyCell.1
            sudoku.partialArray[row][col] = sudoku.sudokuArray[row][col]
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
            
            flashBoardRed()
        }
    }

    
    @IBAction func checkButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            UIView.animate(withDuration: 0.2, animations: {
                self.checkButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.checkButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            })
            
            // Long press started, show error colors
            for row in 0..<9 {
                for col in 0..<9 {
                    let indexPath = IndexPath(row: row * 9 + col, section: 0)
                    guard let cell = collectionView.cellForItem(at: indexPath) as? SudokuCell else {
                        continue
                    }
                    let userValue = sudoku.partialArray[row][col]
                    let correctValue = sudoku.sudokuArray[row][col]
                    if userValue != correctValue {
                        // User input is incorrect
                        cell.label.backgroundColor = UIColor.red
                    } else {
                        // User input is correct
                        cell.label.backgroundColor = UIColor.green
                    }
                }
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            
            UIView.animate(withDuration: 0.2, animations: {
                        self.checkButton.transform = CGAffineTransform.identity
                self.checkButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
                    })
            // Long press ended, reset cell colors
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
    }
        func restart() {
            sudoku.hintsUsed = 0
        // Generate a new Sudoku board
        let boards = generateSudokuBoard()
            sudoku.sudokuArray = boards.0
            sudoku.partialArray = boards.1
        
        // Reset timer and reload collection view data
        seconds = 0
        timer.text = "0:00"
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        time.fire()
        turnCellsToWhite()
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
            sudoku.partialArray[row][col] = value
            
        } else {
            sudoku.partialArray[row][col] = 0
            textField.text = ""
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
        let row = indexPath.row / 9
        let col = indexPath.row % 9

        cell.label.delegate = self
        let value = sudoku.partialArray[row][col]
        cell.label.text = "\(value == 0 ? "" : "\(value)")"
        cell.label.textAlignment = .center // center the text
        cell.label.tag = indexPath.row

        cell.label.isUserInteractionEnabled = value == 0

        // Reset the background color of the cell
        cell.label.backgroundColor = grayedIndices.contains(indexPath.row) ? UIColor.lightGray : UIColor.white

        return cell
    }




    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell
        let cell = collectionView.cellForItem(at: indexPath) as! SudokuCell
        
        print("D:JSDL:KF")
        // Change the background color of the text field for the selected cell
        cell.label.backgroundColor = UIColor.green

    }


}
extension SudokuViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? SudokuCell else { return }
        
        // Clear the array of grayed indices
        grayedIndices.removeAll()
        
        // Add the indices of the cells that should be grayed out to the array
        let indexPath = collectionView.indexPath(for: cell)!
        let row = indexPath.row / 9
        let col = indexPath.row % 9
        for i in 0..<9 {
            if i != col {
                let index = row * 9 + i
                grayedIndices.append(index)
            }
        }
        for j in 0..<9 {
            if j != row {
                let index = j * 9 + col
                grayedIndices.append(index)
            }
        }

        // Change the background color of the selected cell
        cell.label.backgroundColor = UIColor.lightGray

        // Change the background color of all cells in the same row as the selected cell
        for i in 0..<9 {
            if i != col {
                let index = row * 9 + i
                if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? SudokuCell {
                    cell.label.backgroundColor = UIColor.lightGray
                    grayedIndices.append(index)
                }
            }
        }

        // Change the background color of all cells in the same column as the selected cell
        for j in 0..<9 {
            if j != row {
                let index = j * 9 + col
                if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? SudokuCell {
                    cell.label.backgroundColor = UIColor.lightGray
                    grayedIndices.append(index)
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        grayedIndices.removeAll()
        collectionView.reloadData()
        
        
    }



}
