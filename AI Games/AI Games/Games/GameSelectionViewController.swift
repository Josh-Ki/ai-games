//
//  GameSelectionViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/22/23.
//

import Foundation
import UIKit

enum Game {
    case sudoku
    case ttt
    case c4
    case gomoku
}


class GameSelectionViewController: UIViewController {
    
    var selectedLevel : String = ""
    @IBOutlet weak var easy: UIButton!
    
    @IBOutlet weak var med: UIButton!
    
    @IBOutlet weak var hard: UIButton!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var sudokuButton: UIButton!
    @IBOutlet weak var tictactoeButton: UIButton!
    @IBOutlet weak var fourinarowButton: UIButton!
    @IBOutlet weak var gomokuButton: UIButton!
    var selectedGame : Game?
    let sudokuImage = UIImage(named: "sudokuimage.jpeg")
    let tttImage = UIImage(named: "tictactoe.jpeg")

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesLabel.layer.borderWidth = 1
        gamesLabel.layer.borderColor = UIColor.white.cgColor
        customizeButton(sudokuButton)
        customizeButton(tictactoeButton)
        customizeButton(fourinarowButton)
        customizeButton(sudokuButton)
        customizeButton(gomokuButton)

    }
    private func customizeButton(_ button: UIButton) {
        button.tintColor = UIColor.blue
    }
    
    @IBAction func sudokuPressed(_ sender: Any) {
        selectedGame = .sudoku
        sudokuButton.tintColor = UIColor.green
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.blue
        imageView.image = sudokuImage
    }
    
    
    @IBAction func tttPressed(_ sender: Any) {
        selectedGame = .ttt
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.green
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.blue
        imageView.image = tttImage

    }
    
    @IBAction func c4Pressed(_ sender: Any) {
        selectedGame = .c4
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.green
        gomokuButton.tintColor = UIColor.blue

    }
    @IBAction func gomokuPressed(_ sender: Any) {
        selectedGame = .gomoku
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.green

    }
    
    @IBAction func easyPressed(_ sender: Any) {
        easy.tintColor = UIColor.green
        med.tintColor = UIColor.blue
        hard.tintColor = UIColor.blue
        selectedLevel = "Easy"
        
    }
    
    
    @IBAction func medPressed(_ sender: Any) {
        easy.tintColor = UIColor.blue
        med.tintColor = UIColor.green
        hard.tintColor = UIColor.blue
        selectedLevel = "Med"
        
    }
    
    
    @IBAction func hardPressed(_ sender: Any) {
        easy.tintColor = UIColor.blue
        med.tintColor = UIColor.blue
        hard.tintColor = UIColor.green
        selectedLevel = "Hard"
        
    }
    
    @IBAction func playPressed(_ sender: Any) {
        
        if selectedGame == .sudoku {
            let sudokuVC = self.storyboard?.instantiateViewController(
                withIdentifier: "SudokuViewController") as! SudokuViewController
            sudokuVC.selectedDifficulty = selectedLevel
            navigationController?.pushViewController(sudokuVC, animated: true)
        }
        else if selectedGame == .ttt {
            let tttVC = self.storyboard?.instantiateViewController(
                withIdentifier: "TicTacToeViewController") as! TicTacToeViewController

            navigationController?.pushViewController(tttVC, animated: true)
        }
        else if selectedGame == .c4 {
            let c4VC = self.storyboard?.instantiateViewController(
                withIdentifier: "FourInARowViewController") as! FourInARowViewController

            navigationController?.pushViewController(c4VC, animated: true)
        }
        else if selectedGame == .gomoku {
            let gomokuVC = self.storyboard?.instantiateViewController(
                withIdentifier: "GomokuViewController") as! GomokuViewController

            navigationController?.pushViewController(gomokuVC, animated: true)
        }
    }
}


