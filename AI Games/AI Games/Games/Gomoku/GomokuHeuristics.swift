//
//  GomokuHeuristics.swift
//  AI Games
//
//  Created by Tony NGOK on 17/04/2023.
//

// Based on: https://blog.theofekfoundation.org/artificial-intelligence/2015/12/11/minimax-for-gomoku-connect-five/

import Foundation

let winScore = 400000000

// heuristic scores for streak of n (0-4) patterns
// position 0 of subarray n: open pattern score
// position 1 of subarray n: 1-side blocked pattern score
let actualScores = [[0, 0], [2, 1], [10, 4], [20000, 14], [200000000, 200000000]]
let opponentScores = [[0, 0], [2, 1], [10, 4], [100, 10], [1000000, 100]]

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

func validD1(pos: Int) -> Bool {
    if (((pos >= 0) && (pos <= 3)) || ((pos >= 10) && (pos <= 12)) || ((pos == 20) || (pos == 21)) || (pos == 30)) {
        return false
    }
    if (((pos >= 96) && (pos <= 99)) || ((pos >= 87) && (pos <= 89)) || ((pos == 78) || (pos == 79)) || (pos == 69)) {
        return false
    }
    return true
}

func validD2(pos: Int) -> Bool {
    if (((pos >= 6) && (pos <= 9)) || ((pos >= 17) && (pos <= 19)) || ((pos == 28) || (pos == 29)) || (pos == 39)) {
        return false
    }
    if (((pos >= 90) && (pos <= 93)) || ((pos >= 80) && (pos <= 82)) || ((pos == 70) || (pos == 71)) || (pos == 60)) {
        return false
    }
    return true
}

// calculate heuristic score for each pattern
// n: streak of n (0-5) pattern
// block: 0, 1 or 2 blocked sides for pattern
func patternScore(n: Int, block: Int, actualTurn: Bool) -> Int {
    if (n >= 5) {
        return winScore
    }
    
    if ((block == 2) && (n < 5)) {
        return 0
    }
    
    if (actualTurn) {
        return actualScores[n][block]
    }
    return opponentScores[n][block]
}

// «my» heuristic score from horizontal patterns (depending on whether it's «my» turn)
func heurScoreH(gameboard: [String], me: String, turn: String) -> Int {
    var n = 0;
    var block = 2
    var score = 0
    
    for y in 0...9 {
        for x in 0...9 {
            let pos = calcPos(y: y, x: x)
            
            if (gameboard[pos] == me) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of row
        if (n > 0) {
            score += patternScore(n: n, block: block, actualTurn: me == turn)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from vertical patterns (depending on whether it's «my» turn)
func heurScoreV(gameboard: [String], me: String, turn: String) -> Int {
    var n = 0;
    var block = 2
    var score = 0
    
    for x in 0...9 {
        for y in 0...9 {
            let pos = calcPos(y: y, x: x)
            
            if (gameboard[pos] == me) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block, actualTurn: me == turn)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from positive diagonal patterns (depending on whether it's «my» turn)
func heurScoreD1(gameboard: [String], me: String, turn: String) -> Int {
    var n = 0;
    var block = 2
    var score = 0
    
    let indices = genD1Pos(offset: 4) // diagonal indices
    for d in indices {
        for pos in d {
            if (gameboard[pos] == me) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block, actualTurn: me == turn)
        }
        n = 0
        block = 2
    }
    
    return score
}

// «my» heuristic score from negative diagonal patterns (depending on whether it's «my» turn)
func heurScoreD2(gameboard: [String], me: String, turn: String) -> Int {
    var n = 0;
    var block = 2
    var score = 0
    
    let indices = genD2Pos(offset: 4) // diagonal indices
    for d in indices {
        for pos in d {
            if (gameboard[pos] == me) {
                n += 1 // build up streak of n pattern
            } else if ((gameboard[pos] == "") && (n > 0)) { // trailing open end (empty cell)
                block -= 1
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0 // reset streak
                block = 1 // leading open end for next potencial streak pattern
            } else if (gameboard[pos] == "") { // empty cell & no streak pattern
                block = 1
            } else if (n > 0) { // blocked end (opponent piece)
                score += patternScore(n: n, block: block, actualTurn: me == turn)
                n = 0
                block = 2 // no leading open end for next potencial streak pattern
            } else { // opponent piece & no streak pattern
                block = 2
            }
        }
        
        // towards the end of column
        if (n > 0) {
            score += patternScore(n: n, block: block, actualTurn: me == turn)
        }
        n = 0
        block = 2
    }
    
    return score
}

func heurScore(gameboard: [String], me: String, turn: String) -> Int {
    return heurScoreH(gameboard: gameboard, me: me, turn: turn) + heurScoreV(gameboard: gameboard, me: me, turn: turn) + heurScoreD1(gameboard: gameboard, me: me, turn: turn) + heurScoreD2(gameboard: gameboard, me: me, turn: turn)
}
