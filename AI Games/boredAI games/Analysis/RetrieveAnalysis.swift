//
//  RetrieveAnalysis.swift
//  AI Games
//
//  Created by Joshua Ki on 4/16/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
struct SudokuGame {
    let id: String
    let wins: Int
    let time: Int
    let board: [[Int]]
    let hints: Int
    let mistakes: Int
    let mistakesCoordinates: [(Int, Int)]
    let date: String
    
    
}

struct TicTacToeGame {
    let id: String
    let wins: Int
    let lose: Int
    let draw: Int
    let total: Int
    let gameFinished: String
    let image: UIImage
    let date: String
}

struct FourInARowGame {
    let id: String
    let wins: Int
    let lose: Int
    let draw: Int
    let total: Int
    let gameFinished: String
    let board : [[BoardItem]]
    let image: UIImage
    let date: String
    
}

struct GomokuGame {
    let id: String
    let wins: Int
    let lose: Int
    let draw: Int
    let total: Int
    let gameFinished: String
}


extension AnalysisViewController {
    
    func fetchGomokuGamesForWins(userID: String, difficulty: String, completionHandler: @escaping ([GomokuGame]) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/gomoku/difficulty/\(difficulty)")
        collectionRef.order(by: "total", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching gomoku games for wins: \(error)")
                completionHandler([])
                return
            }
            
            var games: [GomokuGame] = []
            
            for doc in snapshot!.documents {
                let data = doc.data()
                let id = data["id"] as! String
                
                let wins = data["wins"] as! Int
                let lose = data["losses"] as! Int
                let draw = data["draw"] as! Int
                let total = data["total"] as! Int
                let gameFinished = data["gameFinished"] as! String
                let game = GomokuGame(id: id, wins: wins, lose: lose, draw: draw, total: total, gameFinished: gameFinished)
                games.append(game)
            }
            
            completionHandler(games)
        }
    }
    
    func boardItem(from dictionary: [String: Any]) -> BoardItem? {
        guard let indexPathRow = dictionary["indexPathRow"] as? Int,
              let indexPathSection = dictionary["indexPathSection"] as? Int,
              let tileRawValue = dictionary["tile"] as? String,
              let tile = Tile(rawValue: tileRawValue) else {
            return nil
        }
        
        var boardItem = BoardItem()
        boardItem.indexPath = IndexPath(row: indexPathRow, section: indexPathSection)
        boardItem.tile = tile
        return boardItem
    }
    
    func fetchConnect4GamesForWins(userID: String, difficulty: String, completionHandler: @escaping ([FourInARowGame]) -> Void) {
            
            let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(difficulty)")
            collectionRef.order(by: "total", descending: false).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching Connect 4 games for wins: \(error)")
                    completionHandler([])
                    return
                }

                let documents = snapshot!.documents
                var games: [FourInARowGame] = []
                var imagesDownloaded = 0

                for doc in documents {
                    let data = doc.data()
                    let id = data["id"] as! String
                    let gameFinished = data["gameFinished"] as! String
                    let wins = data["wins"] as! Int
                    let lose = data["losses"] as! Int
                    let draw = data["draw"] as! Int
                    let total = data["total"] as! Int
                    let boardData = data["board"] as! [[String: Any]]
                    let board = boardData.compactMap { rowDict in
                                        (rowDict["row"] as? [[String: Any]])?.compactMap { itemDict in
                                            self.boardItem(from: itemDict)
                                        }
                                    }
                    
                    let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd"
                    var finalDate = ""
                    if let timestamp = data["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd"
                        let dateInMonthDayFormat = dateFormatter.string(from: date)
                        finalDate = dateInMonthDayFormat
                        // Use the formatted date here
                    }
                    let imageId = data["imageID"]
                    if let user = Auth.auth().currentUser {
                        let uid = user.uid

                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let imageRef = storageRef.child("images/connect4/\(uid)/\(imageId ?? "").png")

                        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                            } else if let data = data {
                                let image = UIImage(data: data)

                                // Create a FourInARowGame object with the downloaded image
                                let game = FourInARowGame(id: id, wins: wins, lose: lose, draw: draw, total: total, gameFinished: gameFinished, board: board, image: image!, date: finalDate)
                                games.append(game)
                            }

                            // Increment the number of images downloaded
                            imagesDownloaded += 1

                            // Check if all images have been downloaded
                            if imagesDownloaded == documents.count {
                                // All images have been downloaded, call the completion handler with the final array of games
                                completionHandler(games)
                            }
                        }
                    }
                }
            }
        }

    
    func fetchTicTacToeGamesForWins(userID: String, difficulty: String, completionHandler: @escaping ([TicTacToeGame]) -> Void) {
        

        let storage = Storage.storage()
            let storageRef = storage.reference()
            
        
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(difficulty)")
        collectionRef.order(by: "total", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching Tic Tac Toe games for wins: \(error)")
                completionHandler([])
                return
            }

            let documents = snapshot!.documents
            var games: [TicTacToeGame] = []
            var imagesDownloaded = 0

            for doc in documents {
                let data = doc.data()
                let id = data["id"] as! String
                let gameFinished = data["gameFinished"] as! String
                let wins = data["wins"] as! Int
                let lose = data["losses"] as! Int
                let draw = data["draw"] as! Int
                let total = data["total"] as! Int
                let imageId = data["imageID"]
                let date = data["date"] as? Timestamp
                let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd"
                var finalDate = ""
                if let timestamp = data["date"] as? Timestamp {
                    let date = timestamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    let dateInMonthDayFormat = dateFormatter.string(from: date)
                    finalDate = dateInMonthDayFormat
                    // Use the formatted date here
                }
                if let user = Auth.auth().currentUser {
                    let uid = user.uid

                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let imageRef = storageRef.child("images/tictactoe/\(uid)/\(imageId ?? "").png")

                    imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            print("Error downloading image: \(error.localizedDescription)")
                        } else if let data = data {
                            let image = UIImage(data: data)

                            // Create a TicTacToeGame object with the downloaded image
                            let game = TicTacToeGame(id: id, wins: wins, lose: lose, draw: draw, total: total, gameFinished: gameFinished, image: image!, date: finalDate)
                            games.append(game)
                        }

                        // Increment the number of images downloaded
                        imagesDownloaded += 1

                        // Check if all images have been downloaded
                        if imagesDownloaded == documents.count {
                            // All images have been downloaded, call the completion handler with the final array of games
                            completionHandler(games)
                        }
                    }
                }
            }
        }
    }
    func fetchGamesAndHints(userID: String, difficulty: String, completion: @escaping ([SudokuGame]) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/sudoku/difficulty/\(difficulty)")
        
        var games = [SudokuGame]()
        
        collectionRef.order(by: "wins", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let wins = data["wins"] as? Int ?? 0
                    let time = data["time"] as? Int ?? 0
                    let hints = data["hints"] as? Int ?? 0
                    let board = data["board"] as? [Int] ?? []
                    let id = data["id"] as? String ?? ""
                    let mistakes = data["mistakes"] as? Int ?? 0
                    let mistakesCoordinates = data["mistakesCoordinates"] as? [[String: Int]] ?? []
                    // Retrieve the date from Firestore
                    let date = data["date"] as? Timestamp
                    let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd"
                    var finalDate = ""
                    if let timestamp = data["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd"
                        let dateInMonthDayFormat = dateFormatter.string(from: date)
                        finalDate = dateInMonthDayFormat
                        // Use the formatted date here
                    }
                    // Create a Game object from the retrieved data
                    let unflattenedBoard = stride(from: 0, to: board.count, by: 9).map {
                        Array(board[$0..<min($0 + 9, board.count)])
                    }
                    
                    let game = SudokuGame(id: id, wins: wins, time: time, board: unflattenedBoard, hints: hints, mistakes: mistakes, mistakesCoordinates: mistakesCoordinates.map { ($0["row"]!, $0["column"]!) }, date: finalDate)
                    
                    // Add the game to your array of games
                    games.append(game)
                }
                // Call the completion closure with the games array
                completion(games)
            }
        }
    }
    
    
}
