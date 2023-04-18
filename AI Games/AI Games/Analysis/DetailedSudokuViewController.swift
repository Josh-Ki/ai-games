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
        
        
    }
    
    
}
