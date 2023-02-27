//
//  GameSelectionViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/22/23.
//

import Foundation
import UIKit

class GameSelectionViewController: UIViewController {

    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var sudokuButton: UIButton!
    @IBOutlet weak var tictactoeButton: UIButton!
    @IBOutlet weak var fourinarowButton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Add a background color to the view
            view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            
            // Animate the label
            animateLabel()
            
            // Customize the buttons
            customizeButton(sudokuButton)
            customizeButton(tictactoeButton)
            customizeButton(fourinarowButton)
        }
        
        // MARK: - Helper methods
        
        private func animateLabel() {
            // Fade in the label
            gamesLabel.alpha = 0.0
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
                self.gamesLabel.alpha = 1.0
            }, completion: nil)
        }
        
        private func customizeButton(_ button: UIButton) {
            // Add a border and round the corners of the button
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0).cgColor
            button.layer.cornerRadius = 10.0
            
            // Add a background color to the button
            button.backgroundColor = UIColor.white
            
            // Add a shadow to the button
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 2.0
            
            // Add a title color to the button
            button.setTitleColor(UIColor.black, for: .normal)
        }


    
    
}
