//
//  DetailedSudokuViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit

class DetailedSudokuViewController: UIViewController {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var mistakesLabel: UILabel!

    
    var gameNumber : Int?
    var hints : Int?
    var mistakes : Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gameLabel.text = "Game \(gameNumber!) Analysis"
        hintsLabel.text = "Hints Used: \(hints!)"
        mistakesLabel.text = "Mistakes Made: \(mistakes!)"
        
    }
    
}
