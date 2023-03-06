//
//  FourInARowViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/21/23.
//
//MARK: Creates the collectionview and cell and includes functionality for the game of four in a row.
import Foundation
import UIKit

class FourInARowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var turnImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var redScore = 0
    var yellowScore = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resetBoard()
        setCellWidthHeight()
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
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // Human player's turn
        
        let column = indexPath.item
        
        guard var boardItem = getLowestEmpty(column),
              let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell else { return }
        
        cell.image.tintColor = currentTurnColor()
        
        boardItem.tile = currentTurnTile()
        updateBoard(boardItem)
        
        if victory() {
            if yellowTurn {
                yellowScore += 1
            } else {
                redScore += 1
            }
            resultAlert(currentTurnVictoryMessage())
        } else if boardIsFull() {
            resultAlert("Draw")
        } else {
            toggleTurn(turnImage)
            
            // Animate piece's movement
            
            let row = boardItem.indexPath.section
            let newIndexPath = IndexPath(item: column, section: row)
            
            let cellAttributes = collectionView.layoutAttributesForItem(at: newIndexPath)
            
            let finalCenter = cellAttributes?.center ?? .zero
            
            let startCenter = CGPoint(x: finalCenter.x,
                                      y: finalCenter.y - collectionView.bounds.height)
            
            cell.center = startCenter
            
            UIView.animate(withDuration: 0.5) {
                cell.center = finalCenter
            }
            
            // AI player's turn
            
            var bestMove: Move?
            
            _  = minimax(depth: 0,
                                maxdepth: 4,
                         bestmove: &bestMove,
                                alpha: Int.min + 1,
                                beta: Int.max - 1)
            
            if let bestMove = bestMove {
                let column = bestMove.column
                
                guard var boardItem = getLowestEmpty(column),
                      let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell else { return }
                
                cell.image.tintColor = currentTurnColor()
                
                boardItem.tile = currentTurnTile()
                
                updateBoard(boardItem)
                
                if victory() {
                    if yellowTurn {
                        yellowScore += 1
                    } else {
                        redScore += 1
                    }
                    resultAlert(currentTurnVictoryMessage())
                } else if boardIsFull() {
                    resultAlert("Draw")
                } else {
                    toggleTurn(turnImage)
                    
                    // Animate piece's movement
                    
                    let row = boardItem.indexPath.section
                    let newIndexPath = IndexPath(item: column, section: row)
                    
                    let cellAttributes = collectionView.layoutAttributesForItem(at: newIndexPath)
                    
                    let finalCenter = cellAttributes?.center ?? .zero
                    
                    let startCenter = CGPoint(x: finalCenter.x,
                                              y: finalCenter.y - collectionView.bounds.height)
                    
                    cell.center = startCenter
                    
                    UIView.animate(withDuration: 0.5) {
                        cell.center = finalCenter
                    }
                }
            }
        }
    }


        
    func resultAlert(_ title: String) {
        let message = "\nRed: \(redScore)\n\nYellow: \(yellowScore)"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { [weak self] _ in
            resetBoard()
            self?.resetCells()
        }))
        present(alert, animated: true)
    }

        
    func resetCells() {
        collectionView.visibleCells.compactMap { $0 as? BoardCell }
            .forEach { $0.image.tintColor = .white }
    }

}
