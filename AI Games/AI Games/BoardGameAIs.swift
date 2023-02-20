//
//  BoardGameAI.swift
//  AI Games
//
//  Created by Tony Ngok on 20/02/2023.
//

import Foundation

// easiest AI: randomly pick legal position
func randomAI(legalPositions: [Int]) -> Int {
    return legalPositions.randomElement()!
}

func minimaxAI(legalPositions:[Int]) -> Int {
    return 0 // to be implemented
}
