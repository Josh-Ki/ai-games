//
//  TicTacToeViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/12/23.
//
//MARK: This View controller creates the tic tac toe board and allows for users to switch between x and o in order to play.

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseStorage

class TicTacToeViewController: UIViewController {
    let user = Auth.auth().currentUser
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var r1c1: UIButton!
    @IBOutlet weak var r1c2: UIButton!
    @IBOutlet weak var r1c3: UIButton!
    @IBOutlet weak var r2c1: UIButton!
    @IBOutlet weak var r2c2: UIButton!
    @IBOutlet weak var r2c3: UIButton!
    @IBOutlet weak var r3c1: UIButton!
    @IBOutlet weak var r3c2: UIButton!
    @IBOutlet weak var r3c3: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    var tictactoe = TicTacToeData()
    var tictactoeEnd = TicTacToeEnd.draw
    let database = Firestore.firestore()
    var selectedDifficulty: String?
    var tttAILevel = 0 // difficulty of AI (easy, medium, invicible)
    

    private func writeTicTacToeData(wins: Int, losses: Int, draws: Int, moves: [String], userID: String, total: Int, imageid: String) {
        var tempState = ""
        if tictactoeEnd == TicTacToeEnd.win {
             tempState = "Win"
        }
        if tictactoeEnd == TicTacToeEnd.draw {
             tempState = "Draw"
        }
        if tictactoeEnd == TicTacToeEnd.lose {
             tempState = "Loss"
        }
            
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()
        
            let data = [
                "id": newDocRef.documentID,
                "wins": wins,
                "losses": losses,
                "draw": draws,
                "moves": moves,
                "gameFinished": tempState,
                "total": total,
                "imageID": imageid,
                "date": Date()
                
            ] as [String : Any]
            
            newDocRef.setData(data)
        }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        switch selectedDifficulty {
        case "Easy":
            tttAILevel = 0
            if user != nil {
                tttGetHighestEasy(difficulty: "Easy", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                    if let highestWins = highestWins {
                        self.tictactoe.easyWins = highestWins
                        print("Highest number of wins for easy: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for easy")
                    }
                    if let highestDraw = highestDraw {
                        self.tictactoe.easyDraw = highestDraw
                        print("Highest number of draw for easy: \(highestDraw)")
                    } else {
                        print("Failed to get highest number of draw for easy")
                    }
                    if let highestLoss = highestLoss {
                        self.tictactoe.easyLoss = highestLoss
                        print("Highest number of loss for easy: \(highestLoss)")
                    } else {
                        print("Failed to get highest number of wins for easy")
                    }
                    
                    if let highestTotal = highestTotal {
                        self.tictactoe.totalEasy = highestTotal
                        print("total number of games is \(highestTotal)")
                    }
                }
            }
        case "Med":
            tttAILevel = 1
            if user != nil {
                tttGetHighestMed(difficulty: "Med", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                    if let highestWins = highestWins {
                        self.tictactoe.medWins = highestWins
                        print("Highest number of wins for easy: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                    if let highestDraw = highestDraw {
                        self.tictactoe.medDraw = highestDraw
                        print("Highest number of draws for med: \(highestDraw)")
                    } else {
                        print("Failed to get highest number of draw for med")
                    }
                    if let highestLoss = highestLoss {
                        self.tictactoe.medLoss = highestLoss
                        print("Highest number of loss for med: \(highestLoss)")
                    } else {
                        print("Failed to get highest number of wins for med")
                    }
                    
                    if let highestTotal = highestTotal {
                        self.tictactoe.totalMed = highestTotal
                        print("total number of games is \(highestTotal)")
                    }
                }
            }
        case "Hard":
            tttAILevel = 2
            if user != nil {
                tttGetHighestMed(difficulty: "Hard", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                    if let highestWins = highestWins {
                        self.tictactoe.hardWins = highestWins
                        print("Highest number of wins for hard: \(highestWins)")
                    } else {
                        print("Failed to get highest number of wins for hard")
                    }
                    if let highestDraw = highestDraw {
                        self.tictactoe.hardDraw = highestDraw
                        print("Highest number of draws for hard: \(highestDraw)")
                    } else {
                        print("Failed to get highest number of draw for hard")
                    }
                    if let highestLoss = highestLoss {
                        self.tictactoe.hardLoss = highestLoss
                        print("Highest number of loss for hard: \(highestLoss)")
                    } else {
                        print("Failed to get highest number of wins for hard")
                    }
                    
                    if let highestTotal = highestTotal {
                        self.tictactoe.totalHard = highestTotal
                        print("total number of games is \(highestTotal)")
                    }
                }
            }
        default:
            print("Defaulted")
            
        }
        
    }
    
    var board = [UIButton]()
    var firstTurn = TicTacToeTurn.x
    var currentTurn = TicTacToeTurn.x
    
    var o = "O"
    var x = "X"
    var oScore = 0
    var xScore = 0
    var userMoves = 0
    
    func sendPicture(image: UIImage) {
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(selectedDifficulty!)")
        let newDocRef = collectionRef.document()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let user = Auth.auth().currentUser {
            let uid = user.uid

            // Include the uid in the path
            tictactoe.imageID = newDocRef.documentID
            let imageRef = storageRef.child("images/tictactoe/\(uid)/\(tictactoe.imageID).png")
            
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
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (addToBoard(sender)) {
            if victory(x) {
                
                
                print(toTTTGameState)
                xScore += 1
                resultAlert(title: "X WINS")
                if user != nil {
                    let image = stackView.snapshot()
                    sendPicture(image: image!)
                    if selectedDifficulty == "Easy"{
                        tictactoe.easyWins += 1
                        tictactoe.totalEasy += 1
                        tictactoeEnd = TicTacToeEnd.win
                        writeTicTacToeData(wins: tictactoe.easyWins, losses: tictactoe.easyLoss, draws: tictactoe.easyDraw, moves: moves, userID: userID, total: tictactoe.totalEasy, imageid: tictactoe.imageID)
                    }
                    else if selectedDifficulty == "Med"{
                        tictactoe.medWins += 1
                        tictactoe.totalMed += 1
                        tictactoeEnd = TicTacToeEnd.win
                        writeTicTacToeData(wins: tictactoe.medWins, losses: tictactoe.medLoss, draws: tictactoe.medDraw, moves: moves, userID: userID, total: tictactoe.totalMed, imageid: tictactoe.imageID)
                    }
                    else if selectedDifficulty == "Hard"{
                        tictactoe.hardWins += 1
                        tictactoe.totalHard += 1
                        tictactoeEnd = TicTacToeEnd.win
                        writeTicTacToeData(wins: tictactoe.hardWins, losses: tictactoe.hardLoss, draws: tictactoe.hardDraw, moves: moves, userID: userID, total: tictactoe.totalHard, imageid: tictactoe.imageID)
                    }
                }
                
            } else if (boardIsFull()) {
               
                resultAlert(title: "Draw")
                if user != nil {
                    let image = stackView.snapshot()
                    sendPicture(image: image!)
                    if selectedDifficulty == "Easy"{
                        tictactoe.easyDraw += 1
                        tictactoe.totalEasy += 1
                        tictactoeEnd = TicTacToeEnd.draw
                        writeTicTacToeData(wins: tictactoe.easyWins, losses: tictactoe.easyLoss, draws: tictactoe.easyDraw, moves: moves, userID: userID, total: tictactoe.totalEasy, imageid: tictactoe.imageID)
                    }
                    else if selectedDifficulty == "Med"{
                        tictactoe.medDraw += 1
                        tictactoe.totalMed += 1
                        tictactoeEnd = TicTacToeEnd.draw
                        writeTicTacToeData(wins: tictactoe.medWins, losses: tictactoe.medLoss, draws: tictactoe.medDraw, moves: moves, userID: userID, total: tictactoe.totalMed, imageid: tictactoe.imageID)
                    }
                    else if selectedDifficulty == "Hard"{
                        tictactoe.hardDraw += 1
                        tictactoe.totalHard += 1
                        tictactoeEnd = TicTacToeEnd.draw
                        writeTicTacToeData(wins: tictactoe.hardWins, losses: tictactoe.hardLoss, draws: tictactoe.hardDraw, moves: moves, userID: userID, total: tictactoe.totalHard, imageid: tictactoe.imageID)
                    }
                }

            } else {
                AIPlays()
            }
        }
    }
    
    func AIPlays() {
        var move = -1
        if (tttAILevel == 0) {
            move = tttRandomMove(gameState: toTTTGameState())
        } else if (tttAILevel == 1) {
            move = tttMedium(gameState: toTTTGameState())
        } else {
            move = tttMinimaxBestMove(gameState: toTTTGameState())
        }
        
        switch move {
        case 0:
            r1c1.setTitle(o, for: .normal)
            break
        case 1:
            r1c2.setTitle(o, for: .normal)
            break
        case 2:
            r1c3.setTitle(o, for: .normal)
            break
        case 3:
            r2c1.setTitle(o, for: .normal)
            break
        case 4:
            r2c2.setTitle(o, for: .normal)
            break
        case 5:
            r2c3.setTitle(o, for: .normal)
            break
        case 6:
            r3c1.setTitle(o, for: .normal)
            break
        case 7:
            r3c2.setTitle(o, for: .normal)
            break
        case 8:
            r3c3.setTitle(o, for: .normal)
            break
        default:
            break
        }
        
        if victory(o) {
            oScore += 1
            resultAlert(title: "O Wins")
            if user != nil {
                let image = stackView.snapshot()
                sendPicture(image: image!)
                if selectedDifficulty == "Easy"{
                    tictactoe.easyLoss += 1
                    tictactoeEnd = TicTacToeEnd.lose
                    tictactoe.totalEasy += 1
                    writeTicTacToeData(wins: tictactoe.easyWins, losses: tictactoe.easyLoss, draws: tictactoe.easyDraw, moves: moves, userID: userID,total: tictactoe.totalEasy, imageid: tictactoe.imageID)
                }
                else if selectedDifficulty == "Med"{
                    tictactoe.medLoss += 1
                    tictactoeEnd = TicTacToeEnd.lose
                    tictactoe.totalMed += 1
                    writeTicTacToeData(wins: tictactoe.medWins, losses: tictactoe.medLoss, draws: tictactoe.medDraw, moves: moves, userID: userID,total: tictactoe.totalMed, imageid: tictactoe.imageID)
                }
                else if selectedDifficulty == "Hard"{
                    tictactoe.hardLoss += 1
                    tictactoeEnd = TicTacToeEnd.lose
                    tictactoe.totalHard += 1
                    writeTicTacToeData(wins: tictactoe.hardWins, losses: tictactoe.hardLoss, draws: tictactoe.hardDraw, moves: moves, userID: userID,total: tictactoe.totalHard, imageid: tictactoe.imageID)
                }
            }
        } else if (boardIsFull()) {
            
            resultAlert(title: "Draw")
            if user != nil {
                let image = stackView.snapshot()
                sendPicture(image: image!)
                if selectedDifficulty == "Easy"{
                    tictactoe.easyDraw += 1
                    tictactoe.totalEasy += 1
                    tictactoeEnd = TicTacToeEnd.draw
                    writeTicTacToeData(wins: tictactoe.easyWins, losses: tictactoe.easyLoss, draws: tictactoe.easyDraw, moves: moves, userID: userID, total: tictactoe.totalEasy, imageid: tictactoe.imageID)
                }
                else if selectedDifficulty == "Med"{
                    tictactoe.medDraw += 1
                    tictactoe.totalMed += 1
                    tictactoeEnd = TicTacToeEnd.draw
                    writeTicTacToeData(wins: tictactoe.medWins, losses: tictactoe.medLoss, draws: tictactoe.medDraw, moves: moves, userID: userID, total: tictactoe.totalMed, imageid: tictactoe.imageID)
                }
                else if selectedDifficulty == "Hard"{
                    tictactoe.hardDraw += 1
                    tictactoe.totalHard += 1
                    tictactoeEnd = TicTacToeEnd.draw
                    writeTicTacToeData(wins: tictactoe.hardWins, losses: tictactoe.hardLoss, draws: tictactoe.hardDraw, moves: moves, userID: userID, total: tictactoe.totalHard, imageid: tictactoe.imageID)
                }
            }
        }
        
        currentTurn = TicTacToeTurn.x
        turnLabel.text = x
    }
    
    func initBoard() {
        board.append(r1c1)
        board.append(r1c2)
        board.append(r1c3)
        board.append(r2c1)
        board.append(r2c2)
        board.append(r2c3)
        board.append(r3c1)
        board.append(r3c2)
        board.append(r3c3)
    }
    
    func boardIsFull() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }

    func resultAlert(title: String) {
        var ac: UIAlertController = UIAlertController()
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        }
        
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        userMoves = 0
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == TicTacToeTurn.o {
            firstTurn = TicTacToeTurn.x
            turnLabel.text = x
        }
        else if firstTurn == TicTacToeTurn.x {
            firstTurn = TicTacToeTurn.o
            turnLabel.text = o
        }
        currentTurn = firstTurn
        if (firstTurn == TicTacToeTurn.o) {
            AIPlays()
        }
    }

    var moves: [String] = []

    func addToBoard(_ sender: UIButton) -> Bool {
        if (sender.title(for: .normal) == nil) {
            if (currentTurn == TicTacToeTurn.x) {
                sender.setTitle(x, for: .normal)
                userMoves += 1
                moves.append("X played at (\(sender.tag / 3), \(sender.tag % 3))") // add move to array
                print("man move \(userMoves)")
                currentTurn = TicTacToeTurn.o
                turnLabel.text = o
            } else {
                sender.setTitle(o, for: .normal)
                userMoves += 1
                moves.append("O played at (\(sender.tag / 3), \(sender.tag % 3))") // add move to array
                print("ai move \(userMoves)")
                currentTurn = TicTacToeTurn.x
                turnLabel.text = x
            }
            sender.isEnabled = false
            return true
        }
        return false
    }

    
    func victory(_ s :String) -> Bool {
        // Horizontal Victory
        if thisSymbol(r1c1, s) && thisSymbol(r1c2, s) && thisSymbol(r1c3, s) {
            return true
        }
        if thisSymbol(r2c1, s) && thisSymbol(r2c2, s) && thisSymbol(r2c3, s) {
            return true
        }
        if thisSymbol(r3c1, s) && thisSymbol(r3c2, s) && thisSymbol(r3c3, s) {
            return true
        }
        
        // Vertical Victory
        if thisSymbol(r1c1, s) && thisSymbol(r2c1, s) && thisSymbol(r3c1, s) {
            return true
        }
        if thisSymbol(r1c2, s) && thisSymbol(r2c2, s) && thisSymbol(r3c2, s) {
            return true
        }
        if thisSymbol(r1c3, s) && thisSymbol(r2c3, s) && thisSymbol(r3c3, s) {
            return true
        }
        
        // Diagonal Victory
        if thisSymbol(r1c1, s) && thisSymbol(r2c2, s) && thisSymbol(r3c3, s) {
            return true
        }
        if thisSymbol(r1c3, s) && thisSymbol(r2c2, s) && thisSymbol(r3c1, s) {
            return true
        }
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func toTTTGameState() -> TicTocToeGameState {
        var gameboard = [r1c1.title(for: .normal) ?? ""]
        gameboard.append(r1c2.title(for: .normal) ?? "")
        gameboard.append(r1c3.title(for: .normal) ?? "")
        gameboard.append(r2c1.title(for: .normal) ?? "")
        gameboard.append(r2c2.title(for: .normal) ?? "")
        gameboard.append(r2c3.title(for: .normal) ?? "")
        gameboard.append(r3c1.title(for: .normal) ?? "")
        gameboard.append(r3c2.title(for: .normal) ?? "")
        gameboard.append(r3c3.title(for: .normal) ?? "")
        
        return TicTocToeGameState(gameboard: gameboard, turn: currentTurn == TicTacToeTurn.x ? "X" : "O")
    }
    
}

extension TicTacToeViewController {
    private func tttGetHighestEasy(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(difficulty)")
        
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
    private func tttGetHighestMed(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(difficulty)")
        
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

    private func tttGetHighestHard(difficulty: String, userID: String, completion: @escaping (Int?, Int?, Int?, Int?) -> Void) {
        let collectionRef = database.collection("/users/\(userID)/tictactoe/difficulty/\(difficulty)")
        
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

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
