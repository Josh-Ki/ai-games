//
//  Extension.swift
//  AI Games
//
//  Created by Joshua Ki on 4/23/23.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

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
    var imageID : String = ""
}


extension GomokuViewController {
    
    func sendPicture(image: UIImage) {
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let user = Auth.auth().currentUser {
            let uid = user.uid

            // Include the uid in the path
            gomokuData.imageID = newDocRef.documentID
            let imageRef = storageRef.child("images/gomoku/\(uid)/\(gomokuData.imageID).png")
            
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
    
    
    func writeGomokuData(wins: Int, losses: Int, draws: Int, userID: String, total: Int, imageid: String) {
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
            "total": total,
            "date": Date(),
            "imageID": imageid
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
