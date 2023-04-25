//
//  Extension.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit


extension FourInARowViewController {
    
    func writeFourInARowData(wins: Int, losses: Int, draws: Int, userID: String, total: Int, board: [[BoardItem]], imageid: String) {
        var tempState = ""
        if fourInARowEnd == FourInARowEnd.win {
            tempState = "Win"
        }
        if fourInARowEnd == FourInARowEnd.draw {
            tempState = "Draw"
        }
        if fourInARowEnd == FourInARowEnd.lose {
            tempState = "Loss"
        }
            
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()
        let boardDict = board.map { row in
             ["row": row.map { item in item.toDictionary() }]
         }
        
        let data = [
            "id": newDocRef.documentID,
            "wins": wins,
            "losses": losses,
            "draw": draws,
            "gameFinished": tempState,
            "total": total,
            "board": boardDict,
            "date": Date(),
            "imageID": imageid
        ] as [String : Any]
            
        newDocRef.setData(data)
    }


     func c4GetHighestEasy(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(difficulty)")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, nil, nil, nil)
            } else {
                var highestWins: Int?
                var highestLoss: Int?
                var highestTotal: Int?
                
                var highestDraw: Int?
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let wins = data["wins"] as! Int
                    let loss = data["losses"] as! Int
                    let draw = data["draw"] as! Int
                    let total = data["total"] as! Int
                    
                    if highestWins == nil || wins > highestWins! {
                        highestWins = wins
                    }
                    if highestDraw == nil || draw > highestDraw! {
                        highestDraw = draw
                    }
                    if highestLoss == nil || loss > highestLoss! {
                        highestLoss = loss
                    }
                    
                    if highestTotal == nil || total > highestTotal! {
                        highestTotal = total
                    }
                }
                
                completion(highestWins, highestTotal, highestLoss, highestDraw)
            }
        }
        
    }
     func c4GetHighestMed(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(difficulty)")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, nil, nil, nil)
            } else {
                var highestWins: Int?
                var highestLoss: Int?
                var highestTotal: Int?
                
                var highestDraw: Int?
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let wins = data["wins"] as! Int
                    let loss = data["losses"] as! Int
                    let draw = data["draw"] as! Int
                    let total = data["total"] as! Int
                    
                    if highestWins == nil || wins > highestWins! {
                        highestWins = wins
                    }
                    if highestDraw == nil || draw > highestDraw! {
                        highestDraw = draw
                    }
                    if highestLoss == nil || loss > highestLoss! {
                        highestLoss = loss
                    }
                    
                    if highestTotal == nil || total > highestTotal! {
                        highestTotal = total
                    }
                }
                
                completion(highestWins, highestTotal, highestLoss, highestDraw)
            }
        }
        
    }

     func c4GetHighestHard(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(difficulty)")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil, nil, nil, nil)
            } else {
                var highestWins: Int?
                var highestLoss: Int?
                var highestTotal: Int?
                
                var highestDraw: Int?
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let wins = data["wins"] as! Int
                    let loss = data["losses"] as! Int
                    let draw = data["draw"] as! Int
                    let total = data["total"] as! Int
                    
                    if highestWins == nil || wins > highestWins! {
                        highestWins = wins
                    }
                    if highestDraw == nil || draw > highestDraw! {
                        highestDraw = draw
                    }
                    if highestLoss == nil || loss > highestLoss! {
                        highestLoss = loss
                    }
                    
                    if highestTotal == nil || total > highestTotal! {
                        highestTotal = total
                    }
                }
                
                completion(highestWins, highestTotal, highestLoss, highestDraw)
            }
        }
        
    }
}
