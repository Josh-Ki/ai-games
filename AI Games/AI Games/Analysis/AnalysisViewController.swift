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

class AnalysisViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let tttTallyView = UIView()

    // Title label
    let titleLabel = UILabel()
    
    // Picker view to select a game
    let gamePickerView = UIPickerView()
    
    // Array of games
    let games = ["Tic Tac Toe", "Sudoku", "Gomoku", "Connect Four"]
    
    
    
    
    // Number of wins and losses for Tic Tac Toe
    
    var tttWins = 0
    var tttLose = 0
    // Logout button
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        for i in 0..<tttWins {
            let winView = UIView()
            winView.backgroundColor = .green
            winView.frame = CGRect(x: i * 10, y: 0, width: 8, height: 40)
            tttTallyView.addSubview(winView)
        }

        for i in 0..<tttLose {
            let loseView = UIView()
            loseView.backgroundColor = .red
            loseView.frame = CGRect(x: i * 10, y: 50, width: 8, height: 40)
            tttTallyView.addSubview(loseView)
        }

        
        // Set up the title label
        titleLabel.text = "Game Analysis"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Set up the picker view
        gamePickerView.delegate = self
        gamePickerView.dataSource = self
        
        
        // Set up the logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Add the views to the view
        view.addSubview(titleLabel)
        view.addSubview(gamePickerView)
        
        view.addSubview(logoutButton)
        view.addSubview(tttTallyView)

        // Set up constraints
        setupConstraints()
    }
    
    
    func setupConstraints() {
        tttTallyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tttTallyView.topAnchor.constraint(equalTo: gamePickerView.bottomAnchor, constant: 20),
            tttTallyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tttTallyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tttTallyView.heightAnchor.constraint(equalToConstant: 90)
        ])

        // Disable autoresizing mask translation
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        gamePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the views
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gamePickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            gamePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gamePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return games.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return games[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGame = games[row]
        
        // Remove any existing views from the tally view
        tttTallyView.subviews.forEach { $0.removeFromSuperview() }
        
        // Update the tally view based on the selected game
        switch selectedGame {
        case "Tic Tac Toe":
            for i in 0..<tttWins {
                let winView = UIView()
                winView.backgroundColor = .green
                winView.frame = CGRect(x: i * 10, y: 0, width: 8, height: 40)
                tttTallyView.addSubview(winView)
            }

            for i in 0..<tttLose {
                let loseView = UIView()
                loseView.backgroundColor = .red
                loseView.frame = CGRect(x: i * 10, y: 50, width: 8, height: 40)
                tttTallyView.addSubview(loseView)
            }
        // Add cases for other games here as well...
        default:
            break
        }
    }

    
    
//
//
    
    let database = Firestore.firestore()
//    @IBOutlet weak var tttWins: UILabel!
//
    override func viewWillAppear(_ animated: Bool) {
        
        let user = Auth.auth().currentUser
        

            if user != nil {
                print("USER IS SIGNED IN")
                let userID = Auth.auth().currentUser?.uid
              // User is signed in
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

