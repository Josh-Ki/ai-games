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
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    var sudokuBoardViewController: SudokuViewController?
    
    var selectedLevel : String = ""
    @IBOutlet weak var easy: UIButton!
    
    @IBOutlet weak var med: UIButton!
    
    @IBOutlet weak var hard: UIButton!
    
    @IBOutlet weak var play: UIButton!
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
        imageView.layer.cornerRadius = 20.0
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)

        
        customizeButton(sudokuButton)
        customizeButton(tictactoeButton)
        customizeButton(fourinarowButton)
        customizeButton(sudokuButton)
        customizeButton(gomokuButton)
        customizeButton(easy)
        customizeButton(med)
        customizeButton(hard)
        customizeButton(play)
        
        
    }
    private func customizeButton(_ button: UIButton) {
        button.layer.cornerRadius = 20.0
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        // Create the alert controller
        print("pressed")
        let alertController = UIAlertController(title: "Welcome to boredAI games", message: "Our app lets you play a variety of board games against an AI opponent. To get started, simply click on the game you want to play and choose a difficulty level (Easy, Medium, or Hard). Once you've made your selection, hit play to begin the game. To track your progress and see how you're improving, make sure to sign up and check out the Analysis tab. Here, you can view your statistics and see how you're doing over time. Don't forget to sign up first so that your progress can be saved! Thanks for playing boredAI games - we hope you have a great time!", preferredStyle: .alert)
        
        // Add the close action
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(closeAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func sudokuPressed(_ sender: Any) {
        // Instantiate the Sudoku board view controller
        let sudokuBoardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SudokuViewController") as! SudokuViewController
        
        // Add the Sudoku board view controller as a child view controller of the GameSelectionViewController
       
        addChild(sudokuBoardViewController)
        sudokuBoardViewController.view.frame = imageView.bounds
        imageView.addSubview(sudokuBoardViewController.view)
        sudokuBoardViewController.didMove(toParent: self)
        
        // Update the selected game and image view
        selectedGame = .sudoku
        sudokuButton.tintColor = UIColor.green
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.blue
        imageView.image = sudokuImage
        sudokuBoardViewController.checkButton.isHidden = true
        sudokuBoardViewController.hintButton.isHidden = true
    }
    
    
    @IBAction func tttPressed(_ sender: Any) {
        
        // Instantiate the Sudoku board view controller
        let tttBoardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TicTacToeViewController") as! TicTacToeViewController
        
        // Add the Sudoku board view controller as a child view controller of the GameSelectionViewController
        addChild(tttBoardViewController)
        tttBoardViewController.view.frame = imageView.bounds
        imageView.addSubview(tttBoardViewController.view)
        tttBoardViewController.didMove(toParent: self)
        
        
        selectedGame = .ttt
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.green
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.blue
        imageView.image = tttImage
        tttBoardViewController.turnLabel.isHidden = true
    }
    
    @IBAction func c4Pressed(_ sender: Any) {
        
        
        
        selectedGame = .c4
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.green
        gomokuButton.tintColor = UIColor.blue
        // Remove the previous child view controller
        for childViewController in children {
            childViewController.removeFromParent()
            childViewController.view.removeFromSuperview()
        }

        // Set the new image
        imageView.image = UIImage(named: "c4board")

        
    }
    @IBAction func gomokuPressed(_ sender: Any) {
        selectedGame = .gomoku
        sudokuButton.tintColor = UIColor.blue
        tictactoeButton.tintColor = UIColor.blue
        fourinarowButton.tintColor = UIColor.blue
        gomokuButton.tintColor = UIColor.green
        // Remove the previous child view controller
        for childViewController in children {
            childViewController.removeFromParent()
            childViewController.view.removeFromSuperview()
        }

        // Set the new image
        imageView.image = UIImage(named: "gomokuboard")
        
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
            // Instantiate the Sudoku board view controller
            let sudokuVC = self.storyboard?.instantiateViewController(withIdentifier: "SudokuViewController") as! SudokuViewController
            sudokuVC.selectedDifficulty = selectedLevel
            
            // Push the SudokuViewController onto the navigation stack
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
