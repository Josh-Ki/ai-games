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

class AnalysisViewController: UIViewController{
    
    var tttWins = 0
    var tttLose = 0
    
    @IBOutlet weak var sudokuButton: UIButton!
    
    @IBOutlet weak var tictactoeButton: UIButton!
    @IBOutlet weak var connect4Button: UIButton!
    @IBOutlet weak var gomokuButton: UIButton!
    
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var lossLabel: UILabel!
    @IBAction func sudokuButtonPressed(_ sender: Any) {
    }
    @IBAction func tictactoeButtonPressed(_ sender: Any) {
        winLabel.text = "Wins: \(tttWins)"
        lossLabel.text = "Wins: \(tttLose)"
        
    }
    
    
    @IBAction func gomokuButtonPressed(_ sender: Any) {
    }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(tttWins)
        print(tttLose)
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
//        for i in 0..<tttWins {
//
//        }
//
//        for i in 0..<tttLose {
//        }


    }
    
    

    
    let database = Firestore.firestore()
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

