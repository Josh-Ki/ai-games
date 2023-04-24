//
//  Extension.swift
//  AI Games
//
//  Created by Joshua Ki on 4/23/23.
//

import Foundation


enum GomokuEnd {
    case win
    case lose
    case draw
}
struct GomokuData {
    var easyWins: Int = 0
    var easyLoss: Int = 0
    var easyDraw: Int = 0
    var medWins: Int = 0
    var medLoss: Int = 0
    var medDraw: Int = 0
    var hardWins: Int = 0
    var hardLoss: Int = 0
    var hardDraw: Int = 0
    var totalEasy: Int = 0
    var totalMed: Int = 0
    var totalHard: Int = 0
}


extension GomokuViewController {
    
    func writeGomokuData(wins: Int, losses: Int, draws: Int, userID: String, total: Int) {
        var tempState = ""
        if gomokuEnd == GomokuEnd.win {
            tempState = "Win"
        }
        if gomokuEnd == GomokuEnd.draw {
            tempState = "Draw"
        }
        if gomokuEnd == GomokuEnd.lose {
            tempState = "Loss"
        }
            
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()

        
        let data = [
            "id": newDocRef.documentID,
            "wins": wins,
            "losses": losses,
            "draw": draws,
            "gameFinished": tempState,
            "total": total
        ] as [String : Any]
            
        newDocRef.setData(data)
    }


     func gomokuGetHighestEasy(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(difficulty)")
        
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
     func gomokuGetHighestMed(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(difficulty)")
        
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

     func gomokuGetHighestHard(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(difficulty)")
        
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
