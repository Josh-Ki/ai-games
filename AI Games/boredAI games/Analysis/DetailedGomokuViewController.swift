//
//  DetailedGomokuViewController.swift
//  boredAI games
//
//  Created by Joshua Ki on 4/25/23.
//

import Foundation
import UIKit

class DetailedGomokuViewController : UIViewController {
    
    @IBOutlet weak var datePlayedLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)

        imageView.image = image
        datePlayedLabel.text = date
    }
}
