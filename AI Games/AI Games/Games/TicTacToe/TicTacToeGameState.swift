//
//  TicTacToeGameState.swift
//  AI Games
//
//  Created by Tony Ngok on 01/03/2023.
//

import Foundation

// https://freecontent.manning.com/classic-computer-science-problems-in-swift-tic-tac-toe/
struct TicTocToeGameState {
    
    let gameboard: [String]
    let turn: String
    var legalMoves: [Int] = []
    var state: Int = -2
    
    init(gameboard: [String], turn: String) {
        self.gameboard = gameboard
        self.turn = turn
        self.legalMoves = getLegalMoves()
        self.state = getState()
    }
    
    private func getLegalMoves() -> [Int] {
        return gameboard.indices.filter {
            gameboard[$0] == ""
        }
    }
    
    private func winLose() -> Int {
        for i in 0...2 {
            if ((gameboard[i] == "X") && (gameboard[i+3] == "X") && (gameboard[i+6] == "X")) {
                return -1
            }
            if ((gameboard[i*3] == "X") && (gameboard[i*3+1] == "X") && (gameboard[i*3+2] == "X")) {
                return -1
            }
            if ((gameboard[i] == "O") && (gameboard[i+3] == "O") && (gameboard[i+6] == "O")) {
                return 1
            }
            if ((gameboard[i*3] == "O") && (gameboard[i*3+1] == "O") && (gameboard[i*3+2] == "O")) {
                return 1
            }
        }
        
        if ((gameboard[0] == "X") && (gameboard[4] == "X") && (gameboard[8] == "X")) {
            return -1
        }
        if ((gameboard[2] == "X") && (gameboard[4] == "X") && (gameboard[6] == "X")) {
            return -1
        }
        if ((gameboard[0] == "O") && (gameboard[4] == "O") && (gameboard[8] == "O")) {
            return 1
        }
        if ((gameboard[2] == "O") && (gameboard[4] == "O") && (gameboard[6] == "O")) {
            return 1
        }
        
        return 0
    }
    
    private func getState() -> Int {
        let wl = winLose()
        if (wl != 0) {
            return wl
        }
        
        if ((wl == 0) && (legalMoves.isEmpty)) {
            return 0
        }
        
        return -2
    }
    
    func move(pos: Int) -> TicTocToeGameState {
        var newGameboard = gameboard
        newGameboard[pos] = turn
        let nextTurn = turn == "X" ? "O" : "X"
        let nextState = TicTocToeGameState(gameboard: newGameboard, turn: nextTurn)
        return nextState
    }
    
}
