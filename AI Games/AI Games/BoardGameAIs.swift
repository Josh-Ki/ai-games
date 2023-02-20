//
//  BoardGameAI.swift
//  AI Games
//
//  Created by Tony Ngok on 20/02/2023.
//

import Foundation

func randomAI(legalPositions: [Int]) -> Int {
    return legalPositions.randomElement()!
}
