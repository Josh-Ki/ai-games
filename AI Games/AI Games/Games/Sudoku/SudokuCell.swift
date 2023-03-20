//
//  SudokuCell.swift
//  AI Games
//
//  Created by Joshua Ki on 3/20/23.
//

import Foundation
import UIKit

class SudokuCell: UICollectionViewCell {
    @IBOutlet weak var label: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}

