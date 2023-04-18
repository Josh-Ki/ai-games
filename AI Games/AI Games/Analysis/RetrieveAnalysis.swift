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
struct SudokuGame {
    let id: String
    let wins: Int
    let time: Int
    let board: [[Int]]
    let hints: Int
    let mistakes: Int
    let mistakesCoordinates: [(Int, Int)]
    
    
}

struct TicTacToeGame {
    let id: String
    let wins: Int
    let lose: Int
    let draw: Int
    let total: Int
    let gameFinished: String
}

struct FourInARowGame {
    let id: String
    let wins: Int
    let lose: Int
    let draw: Int
    let total: Int
    let gameFinished: String
}

extension AnalysisViewController {
    func fetchConnect4GamesForWins(userID: String, difficulty: String, completionHandler: @escaping ([FourInARowGame]) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/connect4/difficulty/\(difficulty)")
        collectionRef.order(by: "total", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching Tic Tac Toe games for wins: \(error)")
                completionHandler([])
                return
            }
            
            var games: [FourInARowGame] = []
            
            for doc in snapshot!.documents {
                let data = doc.data()
                let id = data["id"] as! String
                let gameFinished = data["gameFinished"] as! String
                let wins = data["wins"] as! Int
                let lose = data["losses"] as! Int
                let draw = data["draw"] as! Int
                let total = data["total"] as! Int
                
                let game = FourInARowGame(id: id, wins: wins, lose: lose, draw: draw, total: total, gameFinished: gameFinished)
                games.append(game)
            }
            
            completionHandler(games)
        }
    }
    
    func fetchTicTacToeGamesForWins(userID: String, difficulty: String, completionHandler: @escaping ([TicTacToeGame]) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(difficulty)")
        collectionRef.order(by: "total", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching Tic Tac Toe games for wins: \(error)")
                completionHandler([])
                return
            }
            
            var games: [TicTacToeGame] = []
            
            for doc in snapshot!.documents {
                let data = doc.data()
                let id = data["id"] as! String
                let gameFinished = data["gameFinished"] as! String
                let wins = data["wins"] as! Int
                let lose = data["losses"] as! Int
                let draw = data["draw"] as! Int
                let total = data["total"] as! Int
                
                let game = TicTacToeGame(id: id, wins: wins, lose: lose, draw: draw, total: total, gameFinished: gameFinished)
                games.append(game)
            }
            
            completionHandler(games)
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
                    
                    // Create a Game object from the retrieved data
                    let unflattenedBoard = stride(from: 0, to: board.count, by: 9).map {
                        Array(board[$0..<min($0 + 9, board.count)])
                    }
                    let game = SudokuGame(id: id, wins: wins, time: time, board: unflattenedBoard, hints: hints, mistakes: mistakes, mistakesCoordinates: mistakesCoordinates.map { ($0["row"]!, $0["column"]!) })
                    
                    // Add the game to your array of games
                    games.append(game)
                }
                // Call the completion closure with the games array
                completion(games)
            }
        }
    }
    
    
}
