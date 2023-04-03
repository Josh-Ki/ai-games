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
    
    // Title label
    let titleLabel = UILabel()
    
    // Picker view to select a game
    let gamePickerView = UIPickerView()
    
    // Array of games
    let games = ["Tic Tac Toe", "Sudoku", "Gomoku", "Connect Four"]
    
    // Bar chart view to display wins and losses
    let barChartView = BarChartView()
    
    // Number of wins and losses for Tic Tac Toe
    
    var tttWins = 0
    var tttLose = 0
    // Logout button
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        
        // Set up the title label
        titleLabel.text = "Game Analysis"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Set up the picker view
        gamePickerView.delegate = self
        gamePickerView.dataSource = self
        
        // Set up the bar chart view
        barChartView.wins = tttWins
        barChartView.losses = tttLose
        
        // Set up the logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Add the views to the view
        view.addSubview(titleLabel)
        view.addSubview(gamePickerView)
        view.addSubview(barChartView)
        view.addSubview(logoutButton)
        
        // Set up constraints
        setupConstraints()
    }
    
    func setupConstraints() {
        // Disable autoresizing mask translation
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        gamePickerView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the views
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gamePickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            gamePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gamePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            barChartView.topAnchor.constraint(equalTo: gamePickerView.bottomAnchor, constant: 20),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barChartView.heightAnchor.constraint(equalToConstant: 200),
            
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
        
        // Update the bar chart to display data for the selected game here
        
        if selectedGame == "Tic Tac Toe" {
            barChartView.wins = tttWins
            barChartView.losses = tttLose
        }
        
        // Update the chart for other games here as well...
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
                let docRefWin = database.document("/users/\(userID)/tictactoe/wins")
                let docRefLoss = database.document("/users/\(userID)/tictactoe/loss")
                docRefWin.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let wins = data?["wins"] as? Int ?? 0
                        // Use the retrieved wins value here
                        self.tttWins = wins
                        

                    } else {
                        print("Document does not exist")
                    }
                }
                docRefLoss.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let loss = data?["loss"] as? Int ?? 0
                        // Use the retrieved wins value here
                        self.tttLose = loss
                        

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

class BarChartView: UIView {
    
    // Number of wins and losses to display in the chart
    var wins = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var losses = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let totalGames = wins + losses
        
        if totalGames > 0 {
            let winRatio = CGFloat(wins) / CGFloat(totalGames)
            let lossRatio = CGFloat(losses) / CGFloat(totalGames)
            
            let barWidth = rect.width / 2 - 20
            let barMaxHeight = rect.height - 20
            
            // Draw the win bar
            let winBarHeight = barMaxHeight * winRatio
            let winBarRect = CGRect(x: 10, y: rect.height - winBarHeight, width: barWidth, height: winBarHeight)
            
            context?.setFillColor(UIColor.green.cgColor)
            context?.fill(winBarRect)
            
            // Draw the loss bar
            let lossBarHeight = barMaxHeight * lossRatio
            let lossBarRect = CGRect(x: rect.width / 2 + 10, y: rect.height - lossBarHeight, width: barWidth, height: lossBarHeight)
            
            context?.setFillColor(UIColor.red.cgColor)
            context?.fill(lossBarRect)
        }
    }
}
