//
//  GomokuViewController.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import UIKit

class GomokuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var gameboard: [String] = Array.init(repeating: "", count: 100) // pieces on gameboard
    var backColours: [UIColor] = [] // background colours of gameboard cells
    var foreColours: [UIColor] = Array.init(repeating: UIColor.black, count: 100) // display colours of pieces (only become white when marked in winning sequence)
    var turn = "B"
    var gameOver = false
    
    // https://stackoverflow.com/questions/53768438/collectionview-cell-width-not-changing-for-different-nib
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GomokuCell
        
        let i = indexPath.row
        cell.pieceLabel.text = gameboard[i]
        cell.backgroundColor = backColours[i]
        cell.pieceLabel.textColor = foreColours[i]
//        if (i % 20 < 10) {
//            if (i % 2 == 0) {
//                cell.backgroundColor = UIColor.yellow
//            } else {
//                cell.backgroundColor = UIColor.cyan
//            }
//        } else {
//            if (i % 2 == 0) {
//                cell.backgroundColor = UIColor.cyan
//            } else {
//                cell.backgroundColor = UIColor.yellow
//            }
//        }
        
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
                
                let s = toGameState()
                if (s.state == 20000) {
                    turnLabel.text = "Turn: \(turn)"
                } else {
                    var msg = ""
                    if (s.state == 10000) {
                        msg = "\(bw(abbr: s.me)) WINS"
                    } else if (s.state == -10000) {
                        msg = "\(bw(abbr: s.you)) WINS"
                    } else if (s.state == 0) {
                        msg = "DRAW"
                    }
                    resultAlert(title: msg)
                    turnLabel.text = msg
                    
                    // mark winning sequence on gameboard
                    for i in s.winSeq {
                        backColours[i] = UIColor.red
                        foreColours[i] = UIColor.white
                        
                        // https://stackoverflow.com/questions/29428090/how-to-convert-int-to-nsindexpath
                        gomokuView.reloadItems(at: [IndexPath(item: i, section: 0)])
                    }
                    
                    gameOver = true
                }
            }
        }
    }
    
    @IBOutlet weak var gomokuView: UICollectionView!
    @IBOutlet weak var turnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    func resultAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true)
    }
    
    func bw(abbr: String) -> String {
        if (abbr == "W") {
            return "WHITE"
        }
        return "BLACK"
    }
                            
    func toGameState() -> GomokuGameState {
        let isBlack = turn == "B" ? true : false
        return GomokuGameState(gameboard: gameboard, isBlack: isBlack)
    }

}
