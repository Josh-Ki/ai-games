//
//  DetailedC4ViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/22/23.
//

import Foundation
import UIKit

class DetailedC4ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var board = [[BoardItem]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        
        setCellWidthHeight()
        
        
    }
    func resetBoard() {
        board = (0...5).map { row in
            (0...6).map { column in
                let indexPath = IndexPath(item: column, section: row)
                return BoardItem(indexPath: indexPath, tile: Tile.Empty)
            }
        }
    }

    
    func updateBoard(_ boardItem: BoardItem)
    {
        if let indexPath = boardItem.indexPath
        {
            board[indexPath.section][indexPath.item] = boardItem
        }
    }
    
    func setCellWidthHeight()
    {
        let width = collectionView.frame.size.width / 9
        let height = collectionView.frame.size.height / 6
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    
    func numberOfSections(in cv: UICollectionView) -> Int
        {
            return board.count
        }
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! BoardCell
                
            let boardItem = getBoardItem(indexPath)
            cell.image.tintColor = boardItem.tileColor()
            return cell
    }
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return board[section].count
    }
    
    

}
