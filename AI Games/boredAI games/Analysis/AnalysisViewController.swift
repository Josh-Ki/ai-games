//
//  AnalysisViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/26/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tttWins = 0
    var tttLose = 0
    var selectedGame : Game?
    @IBOutlet weak var easyTableView: UITableView!
    
    @IBOutlet weak var tttEasyTableView: UITableView!
    
    @IBOutlet weak var medTableView: UITableView!
    
    @IBOutlet weak var hardTableView: UITableView!
    
    @IBOutlet weak var sudokuButton: UIButton!
    
    @IBOutlet weak var tictactoeButton: UIButton!
    @IBOutlet weak var connect4Button: UIButton!
    @IBOutlet weak var gomokuButton: UIButton!
    var easyGames: [SudokuGame] = []
    var medGames: [SudokuGame] = []
    var hardGames: [SudokuGame] = []
    var tttEasyGames: [TicTacToeGame] = []
    var tttHardGames: [TicTacToeGame] = []
    var tttMedGames: [TicTacToeGame] = []
    var c4EasyGames: [FourInARowGame] = []
    var c4MedGames: [FourInARowGame] = []
    var c4HardGames: [FourInARowGame] = []
    var gomokuEasyGames: [GomokuGame] = []
    var gomokuMedGames: [GomokuGame] = []
    var gomokuHardGames: [GomokuGame] = []
    
    func animateButton(button: UIButton){
        UIView.animate(withDuration: 0.4, animations: {
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            // Shrink animation
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
    }

    @IBAction func helpButton(_ sender: Any) {
        // Create a new alert controller with a title and message
        let alertController = UIAlertController(title: "analysis", message: "Here you can see all the games you have played for each difficulty in Sudoku, Tic Tac Toe, Gomoku, and Connect 4. Simply click on the game button to see how it ended. For Sudoku, you can also access an additional view controller to review your game statistics and replay the game. Now you can easily track your progress and improve your gameplay.", preferredStyle: .alert)
        
        // Add a "Dismiss" button to the alert
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        // Customize the appearance of the alert
        alertController.view.tintColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        alertController.view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        alertController.view.layer.cornerRadius = 10
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func c4Pressed(_ sender: Any) {
        selectedGame = .c4
        animateButton(button: connect4Button)
        connect4Button.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        sudokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        tictactoeButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        gomokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        
        // Show tables
        easyTableView.isHidden = false
        medTableView.isHidden = false
        hardTableView.isHidden = false
        easyTableView.reloadData()
        medTableView.reloadData()
        hardTableView.reloadData()
    }
    @IBAction func gomokuButtonPressed(_ sender: Any) {
        selectedGame = .gomoku
        animateButton(button: gomokuButton)
        // Change color
        gomokuButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        sudokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        tictactoeButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        connect4Button.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        
        // Show tables
        easyTableView.isHidden = false
        medTableView.isHidden = false
        hardTableView.isHidden = false
        easyTableView.reloadData()
        medTableView.reloadData()
        hardTableView.reloadData()
    }
    
    
    @IBAction func sudokuButtonPressed(_ sender: Any) {
        selectedGame = .sudoku
        // Expand animation

        animateButton(button: sudokuButton)
        // Change color
        sudokuButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        tictactoeButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        connect4Button.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        gomokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        
        // Show tables
        easyTableView.isHidden = false
        medTableView.isHidden = false
        hardTableView.isHidden = false
        easyTableView.reloadData()
        medTableView.reloadData()
        hardTableView.reloadData()
        
        
    }
    @IBAction func tictactoeButtonPressed(_ sender: Any) {
        selectedGame = .ttt
        
        // Expand animation
animateButton(button: tictactoeButton)
        
        sudokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        tictactoeButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        gomokuButton.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        connect4Button.backgroundColor = UIColor(red: 0.999975, green: 0.758761, blue: 0.35136, alpha: 1)
        easyTableView.reloadData()
        medTableView.reloadData()
        hardTableView.reloadData()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (selectedGame, tableView) {
        case (.sudoku, easyTableView):
            return easyGames.count
        case (.sudoku, medTableView):
            return medGames.count
        case (.sudoku, hardTableView):
            return hardGames.count
        case (.ttt, easyTableView):
            return tttEasyGames.count
        case (.ttt, medTableView):
            return tttMedGames.count
        case (.ttt, hardTableView):
            return tttHardGames.count
        case (.c4, easyTableView):
            return c4EasyGames.count
        case (.c4, medTableView):
            return c4MedGames.count
        case (.c4, hardTableView):
            return c4HardGames.count
        case (.gomoku, easyTableView):
            return gomokuEasyGames.count
        case (.gomoku, medTableView):
            return gomokuMedGames.count
        case (.gomoku, hardTableView):
            return gomokuHardGames.count
        default:
            return 0
        }

    }
    private func customizeButton(_ button: UIButton) {
        button.layer.cornerRadius = 20.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SudokuCell", for: indexPath)
        cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
           cell.layer.masksToBounds = true
           cell.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        
        switch tableView {
        case easyTableView:
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            if selectedGame == .sudoku{
                let game = easyGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.wins)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                
                stackView.addArrangedSubview(checkmarkImageView)
                
                // Add time label to stack view
                let timeLabel = UILabel()
                let minutes = game.time / 60
                let seconds = game.time % 60
                let timeString = String(format: "%d:%02d", minutes, seconds)
                
                timeLabel.text = "\(timeString)s"
                stackView.addArrangedSubview(timeLabel)
                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
            }
            
            else if selectedGame == .ttt {
                let game = tttEasyGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                xImageView.tintColor = .red
                let catImageView = UIImageView(image: UIImage(systemName: "pawprint"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
            else if selectedGame == .c4 {
                let game = c4EasyGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
            else if selectedGame == .gomoku {
                let game = gomokuEasyGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
        case medTableView:
            for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        if selectedGame == .sudoku{
            let game = medGames[indexPath.row]
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            stackView.spacing = 8
            
            // Add game number label to stack view
            let gameNumberLabel = UILabel()
            gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
            gameNumberLabel.text = "Game \(game.wins)"
            stackView.addArrangedSubview(gameNumberLabel)
            
            // Add checkmark to stack view
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmarkImageView.tintColor = .green
            
            stackView.addArrangedSubview(checkmarkImageView)
            
            // Add time label to stack view
            let timeLabel = UILabel()
            let minutes = game.time / 60
            let seconds = game.time % 60
            let timeString = String(format: "%d:%02d", minutes, seconds)
            
            timeLabel.text = "\(timeString)s"
            stackView.addArrangedSubview(timeLabel)
            
            // Configure cell with stack view
            cell.contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            ])
        }
        
        else if selectedGame == .ttt {
            let game = tttMedGames[indexPath.row]
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            stackView.spacing = 8
            
            // Add game number label to stack view
            let gameNumberLabel = UILabel()
            gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
            gameNumberLabel.text = "Game \(game.total)"
            stackView.addArrangedSubview(gameNumberLabel)
            
            // Add checkmark to stack view
            let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
            let catImageView = UIImageView(image: UIImage(systemName: "cat"))
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmarkImageView.tintColor = .green
            if game.gameFinished == "Win"{
                stackView.addArrangedSubview(checkmarkImageView)
            }
            if game.gameFinished == "Loss" {
                stackView.addArrangedSubview(xImageView)
            }
            if game.gameFinished == "Draw"{
                stackView.addArrangedSubview(catImageView)
            }
            
            

            
            // Configure cell with stack view
            cell.contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            ])
            
        }
            else if selectedGame == .c4 {
                let game = c4MedGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
            else if selectedGame == .gomoku {
                let game = gomokuMedGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
        case hardTableView:
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            if selectedGame == .sudoku{
                let game = hardGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.wins)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                
                stackView.addArrangedSubview(checkmarkImageView)
                
                // Add time label to stack view
                let timeLabel = UILabel()
                let minutes = game.time / 60
                let seconds = game.time % 60
                let timeString = String(format: "%d:%02d", minutes, seconds)
                
                timeLabel.text = "\(timeString)s"
                stackView.addArrangedSubview(timeLabel)
                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
            }
            
            else if selectedGame == .ttt {
                let game = tttHardGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                

                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
            else if selectedGame == .c4 {
                let game = c4HardGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                

                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
            else if selectedGame == .gomoku {
                let game = gomokuHardGames[indexPath.row]
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .equalCentering
                stackView.spacing = 8
                
                // Add game number label to stack view
                let gameNumberLabel = UILabel()
                gameNumberLabel.font = UIFont(name: "Chalkduster", size: 20)
                gameNumberLabel.text = "Game \(game.total)"
                stackView.addArrangedSubview(gameNumberLabel)
                
                // Add checkmark to stack view
                let xImageView = UIImageView(image: UIImage(systemName: "xmark"))
                let catImageView = UIImageView(image: UIImage(systemName: "cat"))
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = .green
                if game.gameFinished == "Win"{
                    stackView.addArrangedSubview(checkmarkImageView)
                }
                if game.gameFinished == "Loss" {
                    stackView.addArrangedSubview(xImageView)
                }
                if game.gameFinished == "Draw"{
                    stackView.addArrangedSubview(catImageView)
                }
                
                

                
                // Configure cell with stack view
                cell.contentView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                ])
                
            }
        default:
            break
        }

        
        
        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case easyTableView:
            if selectedGame == .sudoku {
                let game = easyGames[indexPath.row]
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailedSudokuViewController") as! DetailedSudokuViewController
                detailVC.mistakes = game.mistakes
                detailVC.hints = game.hints
                detailVC.gameNumber = game.wins
                detailVC.sudokuArray = game.board
                detailVC.date = game.date
                
                // Present the new view controller
            self.navigationController?.pushViewController(detailVC, animated: true)
            }
            if selectedGame == .c4 {
                let game = c4EasyGames[indexPath.row]
                let c4DetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailedC4ViewController") as! DetailedC4ViewController
                print(game.board)
                self.navigationController?.pushViewController(c4DetailVC, animated: true)
            }
        case medTableView:
            if selectedGame == .sudoku {
                
                let game = medGames[indexPath.row]
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailedSudokuViewController") as! DetailedSudokuViewController
                detailVC.mistakes = game.mistakes
                detailVC.hints = game.hints
                detailVC.gameNumber = game.wins
                detailVC.sudokuArray = game.board
                detailVC.date = game.date
                // Present the new view controller
            self.navigationController?.pushViewController(detailVC, animated: true)
            }
        case hardTableView:
            if selectedGame == .sudoku {
                let game = hardGames[indexPath.row]
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailedSudokuViewController") as! DetailedSudokuViewController
                detailVC.mistakes = game.mistakes
                detailVC.hints = game.hints
                detailVC.gameNumber = game.wins
                detailVC.sudokuArray = game.board
                detailVC.date = game.date
                // Present the new view controller
            self.navigationController?.pushViewController(detailVC, animated: true)
            }
        
        default:
            break
        }
        


    }


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sudokuButtonPressed(sudokuButton ?? 0)
        customizeButton(sudokuButton)
        customizeButton(gomokuButton)
        customizeButton(tictactoeButton)
        customizeButton(connect4Button)
        medTableView.delegate = self
        medTableView.dataSource = self
        hardTableView.delegate = self
        hardTableView.dataSource = self
        easyTableView.delegate = self
        easyTableView.dataSource = self

        easyTableView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        medTableView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        hardTableView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
  
        easyTableView.showsVerticalScrollIndicator = false
        medTableView.showsVerticalScrollIndicator = false
        hardTableView.showsVerticalScrollIndicator = false
        
        
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        

    }
    
    

    
    let database = Firestore.firestore()
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        

            if user != nil {
                print("USER IS SIGNED IN")
                let userID = Auth.auth().currentUser?.uid
              // User is signed in
                fetchGamesAndHints(userID: userID!, difficulty: "Easy") { games in
                    self.easyGames = games
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }
                
                fetchGamesAndHints(userID: userID!, difficulty: "Med") { games in
                    self.medGames = games
                    DispatchQueue.main.async {
                        self.medTableView.reloadData()
                    }
                }
                
                fetchGamesAndHints(userID: userID!, difficulty: "Hard") { games in
                    self.hardGames = games
                    DispatchQueue.main.async {
                        self.hardTableView.reloadData()
                    }
                }
                
                fetchTicTacToeGamesForWins(userID: userID!, difficulty: "Easy") { games in
                    self.tttEasyGames = games
                    
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }

                fetchTicTacToeGamesForWins(userID: userID!, difficulty: "Med") { games in
                    self.tttMedGames = games
                    DispatchQueue.main.async {
                        self.medTableView.reloadData()
                    }
                }

                fetchTicTacToeGamesForWins(userID: userID!, difficulty: "Hard") { games in
                    self.tttHardGames = games
                    DispatchQueue.main.async {
                        self.hardTableView.reloadData()
                    }
                }
                fetchConnect4GamesForWins(userID: userID!, difficulty: "Easy") { games in
                    self.c4EasyGames = games
                    
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }

                fetchConnect4GamesForWins(userID: userID!, difficulty: "Med") { games in
                    self.c4MedGames = games
                    DispatchQueue.main.async {
                        self.medTableView.reloadData()
                    }
                }

                fetchConnect4GamesForWins(userID: userID!, difficulty: "Hard") { games in
                    self.c4HardGames = games
                    DispatchQueue.main.async {
                        self.hardTableView.reloadData()
                    }
                }
                fetchGomokuGamesForWins(userID: userID!, difficulty: "Easy") { games in
                    self.gomokuEasyGames = games
                    
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }
                fetchGomokuGamesForWins(userID: userID!, difficulty: "Med") { games in
                    self.gomokuMedGames = games
                    
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }
                fetchGomokuGamesForWins(userID: userID!, difficulty: "Hard") { games in
                    self.gomokuHardGames = games
                    
                    DispatchQueue.main.async {
                        self.easyTableView.reloadData()
                    }
                }
                
                



                let docRefWin =  database.document("/users/\(userID!)/tictactoe/wins")
                let docRefLoss = database.document("/users/\(userID!)/tictactoe/loss")
                docRefWin.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let wins = data?["wins"] as? Int
                        self.tttWins = wins!
                        print(wins!)
                    } else {
                        print("Document does not exist")
                    }
                }
                docRefLoss.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let loss = data?["loss"] as? Int
                        // Use the retrieved wins value here
                        self.tttLose = loss!
                        print(loss!)

                    } else {
                        print("Document does not exist")
                    }
                }


            } else {
                print("USER IS NOT SIGNED IN")
              // User is not signed in
                let vc = self.storyboard?.instantiateViewController(
                    withIdentifier: "AuthenticationViewController") as! AuthenticationViewController

                navigationController?.pushViewController(vc, animated: true)
            }


    }
}

