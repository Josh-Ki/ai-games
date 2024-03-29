//
//  FourInARowViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/21/23.
//
//MARK: Creates the collectionview and cell and includes functionality for the game of four in a row.
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseStorage

class FourInARowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var turnImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var redScore = 0
    var yellowScore = 0
    let user = Auth.auth().currentUser
    var fourInARowData = FourInARowData()
    var fourInARowEnd = FourInARowEnd.draw
    let database = Firestore.firestore()
    var selectedDifficulty: String?
    var maxDepth: Int = 1
    var maxIterations: Int = 50
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        resetBoard()
        
        let user = Auth.auth().currentUser
        
        switch selectedDifficulty {
        case "Easy":
            maxDepth = 3
            maxIterations = 50
                    if user != nil {
                        c4GetHighestEasy(difficulty: "Easy", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                            if let highestWins = highestWins {
                                self.fourInARowData.easyWins = highestWins
                                print("Highest number of wins for easy: \(highestWins)")
                            } else {
                                print("Failed to get highest number of wins for easy")
                            }
                            if let highestDraw = highestDraw {
                                self.fourInARowData.easyDraw = highestDraw
                                print("Highest number of draw for easy: \(highestDraw)")
                            } else {
                                print("Failed to get highest number of draw for easy")
                            }
                            if let highestLoss = highestLoss {
                                self.fourInARowData.easyLoss = highestLoss
                                print("Highest number of loss for easy: \(highestLoss)")
                            } else {
                                print("Failed to get highest number of wins for easy")
                            }
                            
                            if let highestTotal = highestTotal {
                                self.fourInARowData.totalEasy = highestTotal
                                print("total number of games is \(highestTotal)")
                            }
                        }
                
            }
        case "Med":
            maxDepth = 4
            maxIterations = 100
            if user != nil {
                c4GetHighestEasy(difficulty: "Med", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                    if let highestWins = highestWins {
                        self.fourInARowData.medWins = highestWins
                        print("Highest number of wins for easy: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                    if let highestDraw = highestDraw {
                        self.fourInARowData.medDraw = highestDraw
                        print("Highest number of draws for med: \(highestDraw)")
                    } else {
                        print("Failed to get highest number of draw for med")
                    }
                    if let highestLoss = highestLoss {
                        self.fourInARowData.medLoss = highestLoss
                        print("Highest number of loss for med: \(highestLoss)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                    
                    if let highestTotal = highestTotal {
                        self.fourInARowData.totalMed = highestTotal
                        print("total number of games is \(highestTotal)")
                    }
                }
            }
        case "Hard":
            maxDepth = 5
            maxIterations = 400
            if user != nil {
                c4GetHighestEasy(difficulty: "Hard", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                    if let highestWins = highestWins {
                        self.fourInARowData.hardWins = highestWins
                        print("Highest number of wins for hard: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for hard")
                    }
                    if let highestDraw = highestDraw {
                        self.fourInARowData.hardDraw = highestDraw
                        print("Highest number of draws for hard: \(highestDraw)")
                    } else {
                        print("Failed to get highest number of draw for hard")
                    }
                    if let highestLoss = highestLoss {
                        self.fourInARowData.hardLoss = highestLoss
                        print("Highest number of loss for hard: \(highestLoss)")
                    } else {
                        print("Failed to get highest number of wins for hard")
                    }
                    
                    if let highestTotal = highestTotal {
                        self.fourInARowData.totalHard = highestTotal
                        print("total number of games is \(highestTotal)")
                    }
                }
            }
        default:
            print("Defaulted")
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCellWidthHeight()
    }
    
    
    func setCellWidthHeight() {
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = collectionView.frame.size.height
        let width = collectionViewWidth / 9
        let height = collectionViewHeight / 6
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
    
    func sendPicture(image: UIImage) {
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let user = Auth.auth().currentUser {
            let uid = user.uid

            // Include the uid in the path
            fourInARowData.imageID = newDocRef.documentID
            let imageRef = storageRef.child("images/connect4/\(uid)/\(fourInARowData.imageID).png")
            
            if let imageData = image.pngData() {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    } else {
                        print("Image uploaded successfully")
                    }
                }
            }
        }
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
                if user != nil {
                    let image = collectionView.snapshot()
                    sendPicture(image: image!)
                    
                    if selectedDifficulty == "Easy"{
                        fourInARowData.easyWins += 1
                        fourInARowData.totalEasy += 1
                        fourInARowEnd = FourInARowEnd.win
                        writeFourInARowData(wins: fourInARowData.easyWins, losses: fourInARowData.easyLoss, draws: fourInARowData.easyDraw, userID: userID, total: fourInARowData.totalEasy, board: board, imageid: fourInARowData.imageID)
                    }
                    else if selectedDifficulty == "Med"{
                        fourInARowData.medWins += 1
                        fourInARowData.totalMed += 1
                        fourInARowEnd = FourInARowEnd.win
                        writeFourInARowData(wins: fourInARowData.medWins, losses: fourInARowData.medLoss, draws: fourInARowData.medDraw, userID: userID, total: fourInARowData.totalMed, board: board, imageid: fourInARowData.imageID)
                    }
                    else if selectedDifficulty == "Hard"{
                        fourInARowData.hardWins += 1
                        fourInARowData.totalHard += 1
                        fourInARowEnd = FourInARowEnd.win
                        writeFourInARowData(wins: fourInARowData.hardWins, losses: fourInARowData.hardLoss, draws: fourInARowData.hardDraw, userID: userID, total: fourInARowData.totalHard, board: board, imageid: fourInARowData.imageID)
                    }
                }
            }
            else{
                if user != nil {
                    let image = collectionView.snapshot()
                    sendPicture(image: image!)
                    if selectedDifficulty == "Easy"{
                        fourInARowData.easyLoss += 1
                        fourInARowEnd = FourInARowEnd.lose
                        fourInARowData.totalEasy += 1
                        writeFourInARowData(wins: fourInARowData.easyWins, losses: fourInARowData.easyLoss, draws: fourInARowData.easyDraw,userID: userID,total: fourInARowData.totalEasy, board: board, imageid: fourInARowData.imageID)
                    }
                    else if selectedDifficulty == "Med"{
                        fourInARowData.medLoss += 1
                        fourInARowEnd = FourInARowEnd.lose
                        fourInARowData.totalMed += 1
                        writeFourInARowData(wins: fourInARowData.medWins, losses: fourInARowData.medLoss, draws: fourInARowData.medDraw, userID: userID,total: fourInARowData.totalMed, board: board, imageid: fourInARowData.imageID)
                    }
                    else if selectedDifficulty == "Hard"{
                        fourInARowData.hardLoss += 1
                        fourInARowEnd = FourInARowEnd.lose
                        fourInARowData.totalHard += 1
                        writeFourInARowData(wins: fourInARowData.hardWins, losses: fourInARowData.hardLoss, draws: fourInARowData.hardDraw, userID: userID, total: fourInARowData.totalHard, board: board, imageid: fourInARowData.imageID)
                    }
                }
                redScore += 1
            }
            resultAlert(currentTurnVictoryMessage())
            }
            
        
    else if boardIsFull() {
        if user != nil {
            let image = collectionView.snapshot()
            sendPicture(image: image!)
            resultAlert("Draw")
            if selectedDifficulty == "Easy"{
                fourInARowData.easyDraw += 1
                fourInARowData.totalEasy += 1
                fourInARowEnd = FourInARowEnd.draw
                writeFourInARowData(wins: fourInARowData.easyWins, losses: fourInARowData.easyLoss, draws: fourInARowData.easyDraw, userID: userID, total: fourInARowData.totalEasy, board: board, imageid: fourInARowData.imageID)
            }
            else if selectedDifficulty == "Med"{
                fourInARowData.medDraw += 1
                fourInARowData.totalMed += 1
                fourInARowEnd = FourInARowEnd.draw
                writeFourInARowData(wins: fourInARowData.medWins, losses: fourInARowData.medLoss, draws: fourInARowData.medDraw, userID: userID, total: fourInARowData.totalMed, board: board, imageid: fourInARowData.imageID)
            }
            else if selectedDifficulty == "Hard"{
                fourInARowData.hardDraw += 1
                fourInARowData.totalHard += 1
                fourInARowEnd = FourInARowEnd.draw
                writeFourInARowData(wins: fourInARowData.hardWins, losses: fourInARowData.hardLoss, draws: fourInARowData.hardDraw, userID: userID, total: fourInARowData.totalHard, board: board, imageid: fourInARowData.imageID)
            }
        }
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
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                let gameState = GameState(board: board, redTurn: true)
    //            print(gameState.board)
                
                let mctsAI = MCTSAI()
                mctsAI.maxIterations = maxIterations
                mctsAI.maxDepth = maxDepth
    //            _  = minimax(depth: 0,
    //                                maxdepth: 5,
    //                         bestmove: &bestMove,
    //                                alpha: Int.min + 1,
    //                                beta: Int.max - 1)

    //            if let bestMove = bestMove {
        
                let column = mctsAI.findBestMove(gameState: gameState).column
    //            let column = 0
                
                DispatchQueue.main.async { [self] in
                    print(column)
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
                        if user != nil {
                            let image = collectionView.snapshot()
                            sendPicture(image: image!)
                        }
                        resultAlert(currentTurnVictoryMessage())
                    } else if boardIsFull() {
                        if user != nil {
                            let image = collectionView.snapshot()
                            sendPicture(image: image!)
                        }
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
    //                }
                    }
                }
            }
            

        }
    }


        
    func resultAlert(_ title: String) {
        let message = "\nRed: \(redScore)\n\nYellow: \(yellowScore)"
        var alert: UIAlertController = UIAlertController()
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        
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
