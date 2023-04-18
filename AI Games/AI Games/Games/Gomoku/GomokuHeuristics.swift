//
//  GomokuHeuristics.swift
//  AI Games
//
//  Created by Tony NGOK on 17/04/2023.
//

import Foundation

let winScore = 100000

// https://github.com/malikusha/Gomoku/blob/master/gomokuCollection.py
// heuristic scores for streak of n (0-4) patterns
// position 0 of subarray n: open pattern score
// position 1 of subarray n: 1-side blocked pattern score
let patternScores = [[0, 0], [1, 1], [4, 2], [18, 9], [100, 50]]

func calcPos(y: Int, x: Int) -> Int {
    return y*10+x
}

// generate array of positive diagonal indices
private func genD1Pos(offset: Int) -> [[Int]] {
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

// generate array of negative diagonal indices
private func genD2Pos(offset: Int) -> [[Int]] {
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

// calculate heuristic score for each pattern
// n: streak of n (0-5) pattern
// block: 0, 1 or 2 blocked sides for pattern
private func patternScore(n: Int, block: Int) -> Int {
    if (n >= 5) {
        return winScore
    }
    
    if ((block == 2) && (n < 5)) {
        return 0
    }
    
    return patternScores[n][block]
}

// https://blog.theofekfoundation.org/artificial-intelligence/2015/12/11/minimax-for-gomoku-connect-five/
// «my» heuristic score from horizontal patterns (depending on whether it's «my» turn)
private func heurScoreH(gameboard: [String], piece: String) -> Int {
    var n = 0
    var block = 2
    var score = 0
    
    for y in 0...9 {
        for x in 0...9 {
            let pos = calcPos(y: y, x: x)
            
            if (gameboard[pos] == piece) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of row
        if (n > 0) {
            score += patternScore(n: n, block: block)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from vertical patterns (depending on whether it's «my» turn)
private func heurScoreV(gameboard: [String], piece: String) -> Int {
    var n = 0
    var block = 2
    var score = 0
    
    for x in 0...9 {
        for y in 0...9 {
            let pos = calcPos(y: y, x: x)
            
            if (gameboard[pos] == piece) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from positive diagonal patterns (depending on whether it's «my» turn)
private func heurScoreD1(gameboard: [String], piece: String) -> Int {
    var n = 0
    var block = 2
    var score = 0
    
    let indices = genD1Pos(offset: 4) // diagonal indices
    for d in indices {
        for pos in d {
            if (gameboard[pos] == piece) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from negative diagonal patterns (depending on whether it's «my» turn)
private func heurScoreD2(gameboard: [String], piece: String) -> Int {
    var n = 0
    var block = 2
    var score = 0
    
    let indices = genD2Pos(offset: 4) // diagonal indices
    for d in indices {
        for pos in d {
            if (gameboard[pos] == piece) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block)
        }
        n = 0
        block = 2
    }
    
    return score
}

// calculate «my» heuristic score (depending on whose turn)
func heurScore(gameboard: [String], piece: String) -> Int {
    return heurScoreH(gameboard: gameboard, piece: piece) + heurScoreV(gameboard: gameboard, piece: piece) + heurScoreD1(gameboard: gameboard, piece: piece) + heurScoreD2(gameboard: gameboard, piece: piece)
}
