//
//  GomokuHeuristics.swift
//  AI Games
//
//  Created by Tony NGOK on 17/04/2023.
//

import Foundation

let winScore = 100000000

// https://github.com/canberkakcali/gomoku-ai-minimax/blob/master/src/Minimax.java
// heuristic scores for streak of n (0-4) patterns
// position 0 of subarray n: open pattern score
// position 1 of subarray n: 1-side blocked pattern score
let actualScores = [[0, 0], [1, 1], [7, 3], [50000, 10], [1000000, 1000000]]
let opponentScores = [[0, 0], [1, 1], [5, 3], [200, 5], [250000, 200]]

private func calcPos(y: Int, x: Int) -> Int {
    return y*10+x
}

// generate arrays of row indices
private func genRowPos() -> [[Int]] {
    var r = [[Int]]()
    
    for y in 0...9 {
        var rr = [Int]()
        for x in 0...9 {
            rr.append(calcPos(y: y, x: x))
        }
        r.append(rr)
    }
    
    return r
}

// generate arrays of column indices
private func genColPos() -> [[Int]] {
    var r = [[Int]]()
    
    for x in 0...9 {
        var rr = [Int]()
        for y in 0...9 {
            rr.append(calcPos(y: y, x: x))
        }
        r.append(rr)
    }
    
    return r
}

// generate array of positive diagonal indices
private func genDiagPos(offset: Int) -> [[Int]] {
    var r = [[Int]]()
    
    for j in offset...18-offset {
        var rr = [Int]()
        if (j <= 9) {
          for i in 0...j {
            rr.append(calcPos(y: i, x: j-i))
          }
        } else {
          for i in j-9...9 {
            rr.append(calcPos(y: i, x: j-i))
          }
        }
        r.append(rr)
    }
    
    return r
}

// generate arrays of negative diagonal indices
private func genRevDiagPos(offset: Int) -> [[Int]] {
    var r = [[Int]]()
    
    for j in -9+offset...9-offset {
        var rr = [Int]()
        if (j < 0) {
          for i in 0...9+j {
            rr.append(calcPos(y: i, x: i-j))
          }
        } else {
          for i in j...9 {
            rr.append(calcPos(y: i, x: i-j))
          }
        }
        r.append(rr)
    }
    
    return r
}

let rowPos = genRowPos()
let colPos = genColPos()
let diagPos = genDiagPos(offset: 4)
let revDiagPos = genRevDiagPos(offset: 4)

// transposition table: store a list of visited states
// key: gameboard state
// value.0: legal moves
// value.1: AI heuristics (score, winSeq)
// value.2: man heuristics (score, winSeq)
// value.3: AI avantage
// value.4: standardised state (result, winSeq)
var transTable: [[String]: ([Int], (Int, [Int]), (Int, [Int]), Int, (Int, [Int]))] = [:]

// calculate heuristic score for each pattern
// n: streak of n (0-5) pattern
// block: 0, 1 or 2 blocked sides for pattern
private func patternScore(n: Int, block: Int, isMyTurn: Bool) -> Int {
    if (n >= 5) {
        return winScore
    }
    
    if ((block == 2) && (n < 5)) {
        return 0
    }
    
    if (isMyTurn) {
        return actualScores[n][block]
    } else {
        return opponentScores[n][block]
    }
}

// https://blog.theofekfoundation.org/artificial-intelligence/2015/12/11/minimax-for-gomoku-connect-five/
// «my» heuristic score from one-direction patterns (depending on whether it's «my» turn)
// directions: 0 (horizontal), 1 (vertical), 2 (positive diagonal), 3 (negative diagonal)
private func heurScorePart(gameboard: [String], piece: String, direction: Int, isMyTurn: Bool) -> (Int, [Int]) {
    var n = 0
    var block = 2
    var score = 0
    var tempSeq = [Int]()
    var winSeq = [Int]()
    
    var indices = [[Int]]()
    switch direction {
    case 0:
        indices = rowPos
        break
    case 1:
        indices = colPos
        break
    case 2:
        indices = diagPos
        break
    case 3:
        indices = revDiagPos
        break
    default:
        break
    }
    
    for d in indices {
        for pos in d {
            if (gameboard[pos] == piece) {
                n += 1 // build up streak of n pattern
                tempSeq.append(pos) // build up sequence
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block, isMyTurn: isMyTurn) // calculate streak score
                if (n >= 5) {
                    for i in tempSeq {
                        if !winSeq.contains(i) {
                            winSeq.append(i) // build up winning (streak of n>=5) sequence
                        }
                    }
                }
                
                n = 0 // reset streak
                tempSeq.removeAll() // clear the temporary sequence
                
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block, isMyTurn: isMyTurn)
                if (n >= 5) {
                    for i in tempSeq {
                        if !winSeq.contains(i) {
                            winSeq.append(i)
                        }
                    }
                }
                
                n = 0
                tempSeq.removeAll()
                
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of row
        if (n > 0) {
            score += patternScore(n: n, block: block, isMyTurn: isMyTurn)
            if (n >= 5) {
                for i in tempSeq {
                    if !winSeq.contains(i) {
                        winSeq.append(i)
                    }
                }
            }
        }
        n = 0
        tempSeq.removeAll()
        block = 2
    }
    
    return (score, winSeq)
}

// calculate «my» heuristic score (depending on whose turn)
func heurScore(gameboard: [String], piece: String, isMyTurn: Bool) -> (Int, [Int]) {
    var score = 0
    var winSeq = [Int]()
    
    for h in 0...3 {
        let heur = heurScorePart(gameboard: gameboard, piece: piece, direction: h, isMyTurn: isMyTurn)
        score += heur.0
        
        for i in heur.1 {
            if !winSeq.contains(i) {
                winSeq.append(i)
            }
        }
    }
    
    return (score, winSeq)
}
