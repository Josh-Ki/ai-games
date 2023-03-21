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

    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var sudokuButton: UIButton!
    @IBOutlet weak var tictactoeButton: UIButton!
    @IBOutlet weak var fourinarowButton: UIButton!
    @IBOutlet weak var gomokuButton: UIButton!
    var selectedGame : Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesLabel.textColor = UIColor.white
        gamesLabel.backgroundColor = UIColor.blue
        gamesLabel.layer.borderWidth = 1
        gamesLabel.layer.borderColor = UIColor.white.cgColor
        customizeButton(sudokuButton)
        customizeButton(tictactoeButton)
        customizeButton(fourinarowButton)
        customizeButton(sudokuButton)
    }
    private func customizeButton(_ button: UIButton) {
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
    }
    
    @IBAction func sudokuPressed(_ sender: Any) {
        selectedGame = .sudoku
        
    }
    
    
    @IBAction func tttPressed(_ sender: Any) {
        selectedGame = .ttt

    }
    
    @IBAction func c4Pressed(_ sender: Any) {
        selectedGame = .c4

    }
    @IBAction func gomokuPressed(_ sender: Any) {
        selectedGame = .gomoku

    }
    
    @IBAction func playPressed(_ sender: Any) {
        
        if selectedGame == .sudoku {
            let sudokuVC = self.storyboard?.instantiateViewController(
                withIdentifier: "SudokuViewController") as! SudokuViewController

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


