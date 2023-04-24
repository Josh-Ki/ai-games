//
//  File.swift
//  AI Games
//
//  Created by Joshua Ki on 4/18/23.
//

import Foundation
import UIKit


extension SudokuViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }



func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 81
}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as! SudokuCell
        let row = indexPath.row / 9
        let col = indexPath.row % 9

        cell.label.delegate = self
        let value = sudoku.partialArray[row][col]
        cell.label.textColor = UIColor.black
        cell.label.text = "\(value == 0 ? "" : "\(value)")"
        cell.label.textAlignment = .center // center the text
        cell.label.tag = indexPath.row

        cell.label.inputView = UIView(frame: CGRect.zero)
        
        if sudoku.startingArray[row][col] != 0 {
            cell.label.isUserInteractionEnabled = false
        } else {
            cell.label.isUserInteractionEnabled = true
        }
       
        
        // Reset the background color of the cell
        cell.label.backgroundColor = grayedIndices.contains(indexPath.row) ? UIColor.lightGray : UIColor.white

        return cell
    }




    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell
//        let cell = collectionView.cellForItem(at: indexPath) as! SudokuCell
        

    }
    
}
