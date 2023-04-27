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


class SudokuViewController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    let user = Auth.auth().currentUser
    @IBOutlet weak var sudokuLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    var labelTapValue: Int = 0
    var selectedIndexPath: IndexPath?
    @IBOutlet weak var timer: UILabel!
    var time = Timer()
    var seconds = 0
    var toGenerate = true
    @IBOutlet weak var checkButton: UIButton!
    var grayedIndices: [Int] = []
    @IBOutlet weak var hintButton: UIButton!
    var sudoku = Sudoku()
    var selectedDifficulty: String?
    let line1 = UIView()
    let line2 = UIView()
    let line3 = UIView()
    let line4 = UIView()
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    
    let database = Firestore.firestore()


    @IBAction func infoButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "sudoku", message: "Before you start, please note that you need to click on a square before choosing a number to input. To remove a value, simply click on the square and press the delete button.  If you need help, you can click the hint button to receive a value on the board. To check your solution, click the check board button. If your solution is correct, an alert will appear letting you know. If not, the board will flash red.  If you want to see which squares are correct, hold down the check board button. This will change the squares that are correct to green, and the wrong squares to red.", preferredStyle: .alert)
        
        // Add a "Dismiss" button to the alert
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        // Customize the appearance of the alert
        alertController.view.tintColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        alertController.view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        alertController.view.layer.cornerRadius = 10
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.contentInset.bottom = 0

        
        let line1CenterX = UIScreen.main.bounds.width / 3
        let line2CenterX = line1CenterX * 2

        let line3CenterY = line1CenterX
        let line4CenterY = line2CenterX

        
        line1.backgroundColor = .black
        line1.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(line1)
        NSLayoutConstraint.activate([
            line1.widthAnchor.constraint(equalToConstant: 5),
            line1.heightAnchor.constraint(equalTo: collectionView.heightAnchor),
            line1.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            line1.centerXAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: line1CenterX)
        ])

        
        line2.backgroundColor = .black
        line2.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(line2)
        NSLayoutConstraint.activate([
            line2.widthAnchor.constraint(equalToConstant: 5),
            line2.heightAnchor.constraint(equalTo: collectionView.heightAnchor),
            line2.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            line2.centerXAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: line2CenterX)
        ])
        

        line3.backgroundColor = .black
        line3.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(line3)
        NSLayoutConstraint.activate([
            line3.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            line3.heightAnchor.constraint(equalToConstant: 5),
            line3.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            line3.centerYAnchor.constraint(equalTo: collectionView.topAnchor, constant: line3CenterY)
        ])

       
        line4.backgroundColor = .black
        line4.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(line4)
        NSLayoutConstraint.activate([
            line4.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            line4.heightAnchor.constraint(equalToConstant: 5),
            line4.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            line4.centerYAnchor.constraint(equalTo: collectionView.topAnchor, constant: line4CenterY)
        ])
        
        //For UI Testing
        line1.accessibilityIdentifier = "line1"
        line2.accessibilityIdentifier = "line2"
        line3.accessibilityIdentifier = "line3"
        line4.accessibilityIdentifier = "line4"
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label1.isUserInteractionEnabled = true
           label1.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label2.isUserInteractionEnabled = true
           label2.addGestureRecognizer(tapGesture2)

           let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label3.isUserInteractionEnabled = true
           label3.addGestureRecognizer(tapGesture3)
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label4.isUserInteractionEnabled = true
           label4.addGestureRecognizer(tapGesture4)

           let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label5.isUserInteractionEnabled = true
           label5.addGestureRecognizer(tapGesture5)
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label6.isUserInteractionEnabled = true
           label6.addGestureRecognizer(tapGesture6)

           let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label7.isUserInteractionEnabled = true
           label7.addGestureRecognizer(tapGesture7)
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label8.isUserInteractionEnabled = true
           label8.addGestureRecognizer(tapGesture8)

           let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           label9.isUserInteractionEnabled = true
           label9.addGestureRecognizer(tapGesture9)

//        // Register for keyboard notifications
//              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        collectionView.backgroundColor = view.backgroundColor
        //Looks for single or multiple taps.
//         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(checkButtonLongPressed(_:)))
            checkButton.addGestureRecognizer(longPressRecognizer)
        switch selectedDifficulty {
        case "Easy":
            sudoku.maxCellsToFill = 51
            if user != nil {
                getHighestWinsForDifficulty(difficulty: "Easy", userID: userID) { (highestWins) in
                    if let highestWins = highestWins {
                        self.sudoku.easyWins = highestWins
                        print("Highest number of wins for easy: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for easy")
                    }
                }
            }
//            maxCellsToFill = 30
        case "Med":
            sudoku.maxCellsToFill = 31
            if user != nil {
                getHighestWinsForDifficulty(difficulty: "Med", userID: userID) { (highestWins) in
                    if let highestWins = highestWins {
                        self.sudoku.medWins = highestWins
                        print("Highest number of wins for med: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                }
            }
        case "Hard":
            sudoku.maxCellsToFill = 17
            if user != nil {
                getHighestWinsForDifficulty(difficulty: "Hard", userID: userID) { (highestWins) in
                    if let highestWins = highestWins {
                        self.sudoku.hardWins = highestWins
                        print("Highest number of wins for hard: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                }
            }
        default:
            sudoku.maxCellsToFill = 30
        }
        if toGenerate == true {
            (sudoku.sudokuArray, sudoku.partialArray) = generateSudokuBoard()
            sudoku.startingArray = sudoku.partialArray
        }
        else if toGenerate == false {
            print("false")
        }
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

//    @objc private func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return
//        }
//
//        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
//        collectionView.contentInset = insets
//        collectionView.scrollIndicatorInsets = insets
//    }
//
//    @objc private func keyboardWillHide(_ notification: Notification) {
//        collectionView.contentInset = .zero
//        collectionView.scrollIndicatorInsets = .zero
//
//    }
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


    
    private func writeUserData(wins: Int, difficulty: String, userID: String, time: Int, board: [[Int]], hints: Int, mistakes: Int, mistakesCoordinates: [(Int,Int)]) {
        let collectionRef = database.collection("/users/\(userID)/sudoku/difficulty/\(difficulty)")
        let newDocRef = collectionRef.document()
        print(mistakesCoordinates)
        let winData = [
            "id": newDocRef.documentID,
            "wins": wins,
            "time": time,
            "board": board.flatMap { $0 },
            "hints": hints,
            "mistakes": mistakes,
            "mistakesCoordinates": mistakesCoordinates.map { ["row": $0.0, "column": $0.1] },
            "date": Date()
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
    
    

    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let selectedIndexPath = selectedIndexPath else {
            // User has not selected a cell yet
            let alert = UIAlertController(title: "No Square Selected", message: "Please select a square before deleting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let row = selectedIndexPath.row / 9
        let col = selectedIndexPath.row % 9
        
        sudoku.partialArray[row][col] = 0
        collectionView.reloadData()
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
            if user != nil {
                writeUserData(wins: sudoku.easyWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed, mistakes: sudoku.mistakesMade, mistakesCoordinates: sudoku.mistakeCoordinates)
            }
        }
        else if selectedDifficulty! == "Med" {
            sudoku.medWins += 1
            time.invalidate()
            if user != nil {
                writeUserData(wins: sudoku.medWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed, mistakes: sudoku.mistakesMade, mistakesCoordinates: sudoku.mistakeCoordinates)
            }
        }
        else if selectedDifficulty! == "Hard" {
            sudoku.hardWins += 1
            time.invalidate()
            if user != nil {
                writeUserData(wins: sudoku.hardWins, difficulty: selectedDifficulty!, userID: userID, time: timeStringToSeconds(timer.text!), board: sudoku.startingArray, hints: sudoku.hintsUsed, mistakes: sudoku.mistakesMade, mistakesCoordinates: sudoku.mistakeCoordinates)
            }
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
        if verify() {
            let alert = UIAlertController(title: "Solved", message: "You have solved the Sudoku!", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.restart()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(restartAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
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
            sudoku.mistakesMade = 0
            sudoku.mistakeCoordinates = []
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

    
    
 
    @IBAction func change(_ textField: UITextField) {
        print("WHen")
        _ = textField.tag / 9
        _ = textField.tag % 9
        if verify() {
            let alert = UIAlertController(title: "Solved", message: "You have solved the Sudoku!", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.restart()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(restartAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
//        if let text = textField.text, let value = Int(text), value >= 1, value <= 9 {
//            sudoku.partialArray[row][col] = value
//            if sudoku.partialArray[row][col] != sudoku.sudokuArray[row][col]{
//                print("ITS WrONG")
//                sudoku.mistakesMade += 1
//                sudoku.mistakeCoordinates.append((row,col))
//            }
//
//
//        }
//        else {
//            sudoku.partialArray[row][col] = 0
//            textField.text = "df"
    }



}
extension SudokuViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let cell = textField.superview?.superview as? SudokuCell else { return }
        textField.inputAccessoryView = nil
        // Clear the array of grayed indices
        grayedIndices.removeAll()
        let indexPath = collectionView.indexPath(for: cell)!
        selectedIndexPath = indexPath
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
