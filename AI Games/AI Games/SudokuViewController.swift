//
//  SudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
import UIKit

class SudokuViewController: UIViewController, UITextFieldDelegate {

    var textFields: [[UITextField]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gridSize: CGFloat = 9.0
        let squareSize: CGFloat = min(view.bounds.width, view.bounds.height) / gridSize
        let gridWidth = squareSize * gridSize
        let gridHeight = squareSize * gridSize
        let gridX = (view.bounds.width - gridWidth) / 2
        let gridY = (view.bounds.height - gridHeight) / 2
        
        textFields = Array(repeating: Array(repeating: UITextField(), count: Int(gridSize)), count: Int(gridSize))
        
        for row in 0..<Int(gridSize) {
            for col in 0..<Int(gridSize) {
                let square = UIView(frame: CGRect(x: gridX + CGFloat(col) * squareSize,
                                                  y: gridY + CGFloat(row) * squareSize,
                                                  width: squareSize,
                                                  height: squareSize))
                square.backgroundColor = UIColor.white
                square.layer.borderWidth = 2.0
                square.layer.borderColor = UIColor.black.cgColor
                

                
                let textField = UITextField(frame: square.bounds)
                textField.textAlignment = .center
                textField.delegate = self
                textField.font = UIFont.systemFont(ofSize: squareSize / 2)
                square.addSubview(textField)
                textFields[row][col] = textField
                
                view.addSubview(square)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        for row in 0..<textFields.count {
            for col in 0..<textFields[row].count {
                if textFields[row][col] == textField {
                    // Store the value entered by the user in a variable or data structure
                    let enteredValue = textField.text ?? ""
                    print("The value entered at row \(row) and column \(col) is \(enteredValue)")
                }
            }
        }
    }
}

