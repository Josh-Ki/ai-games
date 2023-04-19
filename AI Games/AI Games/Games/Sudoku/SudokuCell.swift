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
        
        // Add a thicker border to the bottom of the cell
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - 4, width: frame.size.width, height: 4)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(bottomBorder)
        
        // Add a thicker border to the right of the cell for every 3rd column
        if (tag + 1) % 3 == 0 {
            let rightBorder = CALayer()
            rightBorder.frame = CGRect(x: frame.size.width - 4, y: 0, width: 4, height: frame.size.height)
            rightBorder.backgroundColor = UIColor.black.cgColor
            layer.addSublayer(rightBorder)
        }
        
        // Add a thicker border to the bottom of the cell for every 3rd row
        if (tag + 1) % 27 == 0 {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0, y: frame.size.height - 4, width: frame.size.width, height: 4)
            bottomBorder.backgroundColor = UIColor.black.cgColor
            layer.addSublayer(bottomBorder)
        }
        
        // Add a thicker border to the right of the cell
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: frame.size.width - 1, y: 0, width: 1, height: frame.size.height)
        rightBorder.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(rightBorder)
        
        // Add a thinner border to the top and left of the cell
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }
}
