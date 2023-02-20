//
//  GenericBoardGame.swift
//  AI Games
//
//  Created by Tony Ngok on 13/02/2023.
//

import Foundation

class GenericBoardGame {
    
    var size: Int = 0
    var gameboard: [[Int]] = []
    var plays: Int = 1
    var winner: Int = 0
    var moves: Int = 0
    
    
    init(gameboardSize: Int, whoStarts: Int) {
        self.size = gameboardSize
        
        for _ in 0...(size-1) {
            self.gameboard.append(Array(repeating: 0, count: size))
        }
        
        self.plays = whoStarts
    }
    
    
    func done() -> Bool { // abstract function to be overriden
        return false
    }
    
    
    func draw() -> Bool { // abstract function to be overriden
        return false
    }
    
    
    func turn() {
        // switch turns
        if (self.plays == 1) {
            self.plays = 2
        } else {
            self.plays = 1
        }
        
        self.moves += 1
    }
    
}
