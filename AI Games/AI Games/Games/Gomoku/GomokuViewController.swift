//
//  GomokuViewController.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import UIKit

var gomokuAILevel = 0 // difficulty of AI (easy, medium, invicible)

// https://stackoverflow.com/questions/31662155/how-to-change-uicollectionviewcell-size-programmatically-in-swift
class GomokuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var gameboard: [String] = Array.init(repeating: "", count: 100) // pieces on gameboard
    var backColours: [UIColor] = [] // background colours of gameboard cells
    var foreColours: [UIColor] = Array.init(repeating: UIColor.black, count: 100) // display colours of pieces (only become white when marked in winning sequence)
    var turn = "B" // black moves first
    var gameOver = false
    
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
        if (!gameOver) {
            let i = indexPath.row
            if (gameboard[i] == "") {
                gameboard[i] = turn
                gomokuView.reloadItems(at: [indexPath])
                
                // switch turn
                if (turn == "B") {
                    turn = "W"
                } else {
                    turn = "B"
                }
                
                let s = toGomokuGameState()
                whatsNext(gameState: s)
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
                msg = "\(bw(abbr: gameState.me)) WINS"
            } else if (gameState.state == -1) {
                msg = "\(bw(abbr: gameState.you)) WINS"
            } else if (gameState.state == 0) {
                msg = "DRAW"
            }
            resultAlert(title: msg)
            turnLabel.text = msg
            
            // mark winning sequence on gameboard
            for i in gameState.winSeq {
                backColours[i] = UIColor.red
                foreColours[i] = UIColor.white
                
                // https://stackoverflow.com/questions/29428090/how-to-convert-int-to-nsindexpath
                gomokuView.reloadItems(at: [IndexPath(item: i, section: 0)])
            }
            
            gameOver = true
        }
    }
    
    func AIPlays() {
        let move = gomokuMinimaxBestMove(gameState: toGomokuGameState(), depth: gomokuAILevel)
        gameboard[move] = turn
        gomokuView.reloadItems(at: [IndexPath(item: move, section: 0)])
        
        if (turn == "B") {
            turn = "W"
        } else {
            turn = "B"
        }
        
        let s = toGomokuGameState()
        whatsNext(gameState: s)
    }
    
    @IBOutlet weak var gomokuView: UICollectionView!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var manPlay: UILabel!
    
    func layout() {
        // https://stackoverflow.com/questions/5677716/how-to-get-the-screen-width-and-height-in-ios
        let w = self.view.frame.size.width
        
        gomokuView.frame = CGRect(x: 10, y: 44, width: w-20, height: w+24)
        turnLabel.frame = CGRect(x: 16, y: 76+w, width: w-32, height: 30)
        manPlay.frame = CGRect(x: 16, y: 114+w, width: w-32, height: 23)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)

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
        
        let man: String = ["BLACK", "WHITE"].randomElement()!
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
        let isBlack = turn == "B" ? true : false
        return GomokuGameState(gameboard: gameboard, isBlack: isBlack)
    }

}
