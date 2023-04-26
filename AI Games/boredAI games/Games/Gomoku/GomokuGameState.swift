//
//  GomokuGameState.swift
//  AI Games
//
//  Created by Tony NGOK on 20/03/2023.
//

import Foundation

class GomokuGameState {
    
    var gameboard: [String] = [] // 10x10 gameboard (100 positions)
    var ai: String = "" // AI
    var man: String = "" // man
    var turn: String = ""
    var legalMoves: [Int] = []
    var aiHeur: (Int, [Int]) = (0, [])
    var manHeur: (Int, [Int]) = (0, [])
    var aiAvant: Int = 0
    var state: (Int, [Int]) = (-2, []) // results: win (1), draw (0), lose (-1) & incomplete (-2); along with winning sequence
//    var winSeq: [Int] = []
    
    init(gameboard: [String], isBlack: Bool) {
        self.gameboard = gameboard
        
        if (isBlack) { // black plays AI
            self.ai = "B"
            self.man = "W"
        } else {
            self.ai = "W"
            self.man = "B"
        }
        self.turn = self.ai
        
        self.refresh()
    }
    
    // called after making or undoing one move (for AI analysis)
    private func refresh() {
        // https://stackoverflow.com/questions/28129401/determining-if-swift-dictionary-contains-key-and-obtaining-any-of-its-values
        if let val = transTable[self.gameboard] {
            self.legalMoves = val.0
            self.aiHeur = val.1
            self.manHeur = val.2
            self.aiAvant = val.3
            self.state = val.4
        } else {
            self.legalMoves = getLegalMoves()
            self.aiHeur = heurScore(gameboard: self.gameboard, piece: self.ai, isMyTurn: self.turn == self.ai)
            self.manHeur = heurScore(gameboard: self.gameboard, piece: self.man, isMyTurn: self.turn == self.man)
            self.aiAvant = aiHeur.0 - manHeur.0
            self.state = getState()
            transTable[self.gameboard] = (self.legalMoves, self.aiHeur, self.manHeur, self.aiAvant, self.state)
            print("Trans table size:", transTable.count)
        }
    }
    
    private func getLegalMoves() -> [Int] {
        return gameboard.indices.filter {
            gameboard[$0] == ""
        }
    }
    
    private func getState() -> (Int, [Int]) {
        if (self.manHeur.0 >= winScore) {
            return (-1, self.manHeur.1)
            
        } else if (self.aiHeur.0 >= winScore) {
            return (1, self.aiHeur.1)
        } else if (legalMoves.isEmpty) {
            return (0, []) // draw if no legal moves left
        }
        
        return (-2, [])
    }
    
    func move(pos: Int) {
        self.gameboard[pos] = self.turn
        self.refresh()
        self.turn = self.turn == self.ai ? self.man : self.ai // switch turn
    }
    
    func backMove(pos: Int) {
        self.gameboard[pos] = ""
        self.refresh()
        self.turn = self.turn == self.ai ? self.man : self.ai
    }
    
}
