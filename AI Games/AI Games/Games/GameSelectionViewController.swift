//
//  GameSelectionViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/22/23.
//

import Foundation
import UIKit


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
        
        gamesLabel.textColor = UIColor.white
        gamesLabel.backgroundColor = UIColor.blue
        gamesLabel.layer.borderWidth = 1
        gamesLabel.layer.borderColor = UIColor.white.cgColor
        customizeButton(sudokuButton)
        customizeButton(tictactoeButton)
        customizeButton(fourinarowButton)
        
    }
    private func customizeButton(_ button: UIButton) {
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
    }
}


