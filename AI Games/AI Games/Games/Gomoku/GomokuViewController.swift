//
//  GomokuViewController.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Firebase

// https://stackoverflow.com/questions/31662155/how-to-change-uicollectionviewcell-size-programmatically-in-swift
class GomokuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var gameboard: [String] = Array.init(repeating: "", count: 100) // pieces on gameboard
    var backColours: [UIColor] = [] // background colours of gameboard cells
    var foreColours: [UIColor] = Array.init(repeating: UIColor.black, count: 100) // display colours of pieces (only become white when marked in winning sequence)
    var turn = "B" // black moves first
    var manTurn = "B"
    var gameOver = false
    var selectedDifficulty: String?
    var gomokuAILevel = 0 // difficulty of AI (easy, medium, hard)
    var lastMove = -1
    let database = Firestore.firestore()
    var gomokuData = GomokuData()
    var gomokuEnd = GomokuEnd.draw
    // https://stackoverflow.com/questions/53768438/collectionview-cell-width-not-changing-for-different-nib
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: gomokuView.frame.width/10.0, height: gomokuView.frame.width/10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GomokuCell
        
        let i = indexPath.row
        cell.pieceLabel.text = gameboard[i]
        cell.backgroundColor = backColours[i]
        cell.pieceLabel.textColor = foreColours[i]
        cell.pieceLabel.frame = CGRect(x: 8, y: 8, width: cell.frame.width-16, height: cell.frame.height-16)
        cell.pieceLabel.font = .boldSystemFont(ofSize: cell.pieceLabel.frame.width-4)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (lastMove >= 0) {
            foreColours[lastMove] = UIColor.black
            gomokuView.reloadItems(at: [IndexPath(item: lastMove, section: 0)])
        }

        
        if (!gameOver) {
            let i = indexPath.row
            if (gameboard[i] == "") {
                gameboard[i] = turn
                lastMove = i
                foreColours[i] = UIColor.red
                gomokuView.reloadItems(at: [indexPath])
                
                // switch turn
                if (turn == "B") {
                    turn = "W"
                } else {
                    turn = "B"
                }
                
                let s = toGomokuGameState()
                whatsNext(gameState: s)
                if gameOver {
                    if selectedDifficulty == "Easy"{
                        gomokuData.easyWins += 1
                        gomokuData.totalEasy += 1
                        gomokuEnd = GomokuEnd.win
                        writeGomokuData(wins: gomokuData.easyWins, losses: gomokuData.easyLoss, draws: gomokuData.easyDraw, userID: userID, total: gomokuData.totalEasy)
                    }
                    else if selectedDifficulty == "Med"{
                        gomokuData.medWins += 1
                        gomokuData.totalMed += 1
                        gomokuEnd = GomokuEnd.win
                        writeGomokuData(wins: gomokuData.medWins, losses: gomokuData.medLoss, draws: gomokuData.medDraw, userID: userID, total: gomokuData.totalMed)
                    }
                    else if selectedDifficulty == "Hard"{
                        gomokuData.hardWins += 1
                        gomokuData.totalHard += 1
                        gomokuEnd = GomokuEnd.win
                        writeGomokuData(wins: gomokuData.hardWins, losses: gomokuData.hardLoss, draws: gomokuData.hardDraw, userID: userID, total: gomokuData.totalHard)
                    }
                    
                }
                if (s.state == -2) {
                    AIPlays()
                }
            }
        }

    }
    
    func whatsNext(gameState: GomokuGameState) {
        if (gameState.state == -2) {
            turnLabel.text = "Turn: \(turn)"
        } else {
            var msg = ""
            if (gameState.state == 1) {
                msg = "\(bw(abbr: gameState.ai)) WINS"
            } else if (gameState.state == -1) {
                print("USER WINS")
                msg = "\(bw(abbr: gameState.man)) WINS"
            } else if (gameState.state == 0) {
                msg = "DRAW"
            }
            resultAlert(title: msg)
            turnLabel.text = msg
            
            // mark winning sequence on gameboard
            for i in gameState.winSeq {
                if (i == lastMove) {
                    backColours[i] = UIColor.red
                } else {
                    backColours[i] = UIColor.purple
                }
                foreColours[i] = UIColor.white
                
                // https://stackoverflow.com/questions/29428090/how-to-convert-int-to-nsindexpath
                gomokuView.reloadItems(at: [IndexPath(item: i, section: 0)])
            }
            
            gameOver = true
        }
    }
    
    func AIPlays() {
        gomokuView.isUserInteractionEnabled = false
        manPlay.text = "AI playing \(bw(abbr: turn))"
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let move = gomokuMinimaxBestMove(gameState: toGomokuGameState(), depth: gomokuAILevel)
            
            DispatchQueue.main.async { [self] in
                gameboard[move] = turn
                
                if (lastMove >= 0) {
                    foreColours[lastMove] = UIColor.black
                    gomokuView.reloadItems(at: [IndexPath(item: lastMove, section: 0)])
                }
                
                lastMove = move
                foreColours[move] = UIColor.red
                gomokuView.reloadItems(at: [IndexPath(item: move, section: 0)])
                
                if (turn == "B") {
                    turn = "W"
                } else {
                    turn = "B"
                }
                
                let s = toGomokuGameState()
                whatsNext(gameState: s)
                if gameOver {
                    if selectedDifficulty == "Easy"{
                        gomokuData.easyLoss += 1
                        gomokuData.totalEasy += 1
                        gomokuEnd = GomokuEnd.lose
                        writeGomokuData(wins: gomokuData.easyWins, losses: gomokuData.easyLoss, draws: gomokuData.easyDraw, userID: userID, total: gomokuData.totalEasy)
                    }
                    else if selectedDifficulty == "Med"{
                        gomokuData.medLoss += 1
                        gomokuData.totalMed += 1
                        gomokuEnd = GomokuEnd.lose
                        writeGomokuData(wins: gomokuData.medWins, losses: gomokuData.medLoss, draws: gomokuData.medDraw, userID: userID, total: gomokuData.totalMed)
                    }
                    else if selectedDifficulty == "Hard"{
                        gomokuData.hardLoss += 1
                        gomokuData.totalHard += 1
                        gomokuEnd = GomokuEnd.lose
                        writeGomokuData(wins: gomokuData.hardWins, losses: gomokuData.hardLoss, draws: gomokuData.hardDraw, userID: userID, total: gomokuData.totalHard)
                    }
                }
                manPlay.text = "Man plays \(bw(abbr: turn))"
                gomokuView.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBOutlet weak var gomokuView: UICollectionView!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var manPlay: UILabel!
    
    func layout() {
        // https://stackoverflow.com/questions/5677716/how-to-get-the-screen-width-and-height-in-ios
        let w = self.view.frame.size.width
        
        gomokuView.frame = CGRect(x: 10, y: 44, width: w-20, height: w+24)
        gomokuView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        turnLabel.frame = CGRect(x: 16, y: 76+w, width: w-32, height: 30)
        manPlay.frame = CGRect(x: 16, y: 114+w, width: w-32, height: 23)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        
        switch selectedDifficulty {
        case "Easy":
            
            gomokuGetHighestEasy(difficulty: "Easy", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                if let highestWins = highestWins {
                    self.gomokuData.easyWins = highestWins
                    print("Highest number of wins for easy for gomoku: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for easy for gomoku")
                }
                if let highestDraw = highestDraw {
                    self.gomokuData.easyDraw = highestDraw
                    print("Highest number of draw for easy: \(highestDraw)")
                } else {
                    print("Failed to get highest number of draw for easy")
                }
                if let highestLoss = highestLoss {
                    self.gomokuData.easyLoss = highestLoss
                    print("Highest number of loss for easy for gomoku: \(highestLoss)")
                } else {
                    print("Failed to get highest number of loss for easy for gomoku")
                }
                
                if let highestTotal = highestTotal {
                    self.gomokuData.totalEasy = highestTotal
                    print("total number of games is for gomoku \(highestTotal)")
                }
                
            }
        case "Med":
            
            gomokuGetHighestEasy(difficulty: "Med", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                if let highestWins = highestWins {
                    self.gomokuData.medWins = highestWins
                    print("Highest number of wins for easy for gomoku: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for med for gomoku")
                }
                if let highestDraw = highestDraw {
                    self.gomokuData.medDraw = highestDraw
                    print("Highest number of draws for med for gomoku: \(highestDraw)")
                } else {
                    print("Failed to get highest number of draw for med for gomoku")
                }
                if let highestLoss = highestLoss {
                    self.gomokuData.medLoss = highestLoss
                    print("Highest number of loss for med for gomoku: \(highestLoss)")
                } else {
                    print("Failed to get highest number of wins for med")
                }
                
                if let highestTotal = highestTotal {
                    self.gomokuData.totalMed = highestTotal
                    print("total number of games is \(highestTotal) for gomoku")
                }
                
            }
        case "Hard":
            
            gomokuGetHighestEasy(difficulty: "Hard", userID: userID) { (highestWins, highestTotal, highestLoss, highestDraw) in
                if let highestWins = highestWins {
                    self.gomokuData.hardWins = highestWins
                    print("Highest number of wins for hard for gomoku: \(highestWins)")
                } else {
                    print("Failed to get highest number of wins for hard")
                }
                if let highestDraw = highestDraw {
                    self.gomokuData.hardDraw = highestDraw
                    print("Highest number of draws for hard for gomoku: \(highestDraw)")
                } else {
                    print("Failed to get highest number of draw for hard")
                }
                if let highestLoss = highestLoss {
                    self.gomokuData.hardLoss = highestLoss
                    print("Highest number of loss for hard: \(highestLoss) for gomoku")
                } else {
                    print("Failed to get highest number of loss for hard for gomoku")
                }
                
                if let highestTotal = highestTotal {
                    self.gomokuData.totalHard = highestTotal
                    print("total number of games is \(highestTotal) for gomoku")
                }
                
            }
        default:
            print("Defaulted")
            
        }
        // Do any additional setup after loading the view.
        layout()
        
        for i in 0...99 { // initialise colours of gameboard cells
            if (i % 20 < 10) {
                if (i % 2 == 0) {
                    backColours.append(UIColor.yellow)
                } else {
                    backColours.append(UIColor.cyan)
                }
            } else {
                if (i % 2 == 0) {
                    backColours.append(UIColor.cyan)
                } else {
                    backColours.append(UIColor.yellow)
                }
            }
        }
        
        gomokuView.delegate = self
        gomokuView.dataSource = self
        
        switch selectedDifficulty {
        case "Easy":
            gomokuAILevel = 0
        case "Med":
            gomokuAILevel = 1
        case "Hard":
            gomokuAILevel = 2
        default:
            print("Defaulted")
        }
        
        let man: String = ["BLACK", "WHITE"].randomElement()!
        manTurn = man == "BLACK" ? "B" : "W"
        manPlay.text = "Man plays \(man)"
        if (man == "WHITE") {
            AIPlays() // randomly let AI or human start first
        }
    }
    
    func resultAlert(title: String) {
        var ac: UIAlertController = UIAlertController()
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        }
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true)
    }
    
    func bw(abbr: String) -> String {
        if (abbr == "W") {
            return "WHITE"
        }
        return "BLACK"
    }
                            
    func toGomokuGameState() -> GomokuGameState {
        let isBlack = manTurn != "B"
        return GomokuGameState(gameboard: gameboard, isBlack: isBlack)
    }

}
