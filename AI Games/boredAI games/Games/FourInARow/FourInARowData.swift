//
//  FourInARowData.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit
import FirebaseAuth


enum FourInARowEnd {
    case win
    case lose
    case draw
}
struct FourInARowData {
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
    var imageID : String = ""
}
