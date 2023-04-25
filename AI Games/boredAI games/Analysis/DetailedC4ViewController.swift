//
//  DetailedC4ViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/22/23.
//

import Foundation
import UIKit

class DetailedC4ViewController: UIViewController {
    
        
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var date: String?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView.image = image
        dateLabel.text = date
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        
        
    }
}
