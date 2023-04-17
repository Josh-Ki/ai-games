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
        switch tableView {
        case easyTableView:
            if selectedGame == .sudoku {
                return easyGames.count
            }
            if selectedGame == .ttt {
                return tttEasyGames.count
            }
            return easyGames.count
        case medTableView:
            if selectedGame == .sudoku {
                return medGames.count
            }
            if selectedGame == .ttt {
                return tttMedGames.count
            }
            return medGames.count
        case hardTableView:
            if selectedGame == .sudoku {
                return hardGames.count
            }
            if selectedGame == .ttt {
                return tttHardGames.count
            }
            return hardGames.count
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
        default:
            break
        }

        
        
        return cell
    }



    


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        easyTableView.isHidden = true
        medTableView.isHidden = true
        hardTableView.isHidden = true
        
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
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
//        for i in 0..<tttWins {
//
//        }
//
//        for i in 0..<tttLose {
//        }


    }
    
    

    
    let database = Firestore.firestore()
    override func viewWillAppear(_ animated: Bool) {
        

    }
//
//
    @objc func logoutButtonTapped() {
          // Handle logout here
        print("Clicked")
        do {
                try Auth.auth().signOut()
                // User logged out successfully
                // Navigate to previous screen or perform any other action
//                let authenticationViewController = AuthenticationViewController()
//                self.navigationController?.pushViewController(authenticationViewController, animated: true)
            } catch {
                // Error logging out user
                // Display error message to user
            }
      }
//
////
//
}

