//
//  SudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//

import UIKit

class SudokuViewController: UIViewController, UITextFieldDelegate {
    
    let gridSize: CGFloat = 9.0 // use a constant for the grid size
    var textFields: [UITextField] = [] // use a single array for the text fields
    var timerLabel: UILabel! // add a label for the timer
    var timer: Timer! // add a timer
    var seconds: Int = 0 // add a variable for the seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray // change the background color
        let squareSize: CGFloat = min(view.bounds.width, view.bounds.height) / gridSize
        let gridWidth = squareSize * gridSize
        let gridHeight = squareSize * gridSize
        let gridX = (view.bounds.width - gridWidth) / 2
        let gridY = (view.bounds.height - gridHeight) / 2
        let titleLabel = UILabel(frame: CGRect(x: gridX, y: gridY - 50, width: gridWidth, height: 40)) // add a label for the title
        titleLabel.text = "Sudoku" // set the title text
        titleLabel.textAlignment = .center // center the title text
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40) // set the title font
        titleLabel.textColor = UIColor.black // set the title color
        view.addSubview(titleLabel) // add the title label to the view
        timerLabel = UILabel(frame: CGRect(x: gridX, y: gridY + gridHeight + 10, width: gridWidth, height: 40)) // add a label for the timer
        timerLabel.text = "00:00" // set the timer text
        timerLabel.textAlignment = .center // center the timer text
        timerLabel.font = UIFont.systemFont(ofSize: 30) // set the timer font
        timerLabel.textColor = UIColor.black // set the timer color
        view.addSubview(timerLabel) // add the timer label to the view
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true) // start the timer
        for i in 0..<81 { // use a loop to create the text fields and squares
            let row = i / 9
            let col = i % 9
            let square = UIView(frame: CGRect(x: gridX + CGFloat(col) * squareSize, y: gridY + CGFloat(row) * squareSize, width: squareSize, height: squareSize))
            square.backgroundColor = UIColor.white
            square.layer.borderWidth = 2.0
            square.layer.borderColor = UIColor.black.cgColor
            let textField = UITextField(frame: square.bounds)
            textField.textAlignment = .center
            textField.delegate = self
            textField.font = UIFont.systemFont(ofSize: squareSize / 2)
            textField.tag = i // use a tag property to identify the text field
            square.addSubview(textField)
            textFields.append(textField) // append the text field to the array
            view.addSubview(square)
        }
    }

    @objc func updateTimer() { // add a function to update the timer
        seconds += 1 // increment the seconds
        let minutes = seconds / 60 // get the minutes
        let seconds = seconds % 60 // get the remaining seconds
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds) // update the timer text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let enteredValue = textField.text ?? "" // get the value entered by the user
        print("The value entered at row \(textField.tag / 9) and column \(textField.tag % 9) is \(enteredValue)") // use the tag property to get the row and column
        switch enteredValue { // use a switch statement to validate the input
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            // store the value in a variable or data structure
            textField.textColor = UIColor.blue // change the text color to blue
            break
        default:
            // show an error message or clear the text field
            textField.text = "" // clear the text field
            textField.textColor = UIColor.red // change the text color to red
            break
        }
    }
    
}
