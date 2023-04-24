//
//  TicTacToeTurn.swift
//  AI Games
//
//  Created by Joshua Ki on 2/27/23.
//

import Foundation
enum TicTacToeTurn {
    case x
    case o
}

enum TicTacToeEnd {
    case win
    case lose
    case draw
}
struct TicTacToeData {
    var easyWins: Int = 0
    var easyLoss: Int = 0
    var easyDraw: Int = 0
    var medWins: Int = 0
    var medLoss: Int = 0
    var medDraw: Int = 0
    var hardWins: Int = 0
    var hardLoss: Int = 0
    var hardDraw: Int = 0
    var totalEasy: Int = 0
    var totalMed: Int = 0
    var totalHard: Int = 0
}
