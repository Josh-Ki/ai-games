//
//  Turn.swift
//  AI Games
//
//  Created by Joshua Ki on 2/21/23.
//

import Foundation
import UIKit

var yellowTurn = true // true means yellow turn, false means red turn

func toggleTurn(_ turnImage: UIImageView)
{
    yellowTurn.toggle() // switch between true and false
    turnImage.tintColor = currentTurnColor()
}

func currentTurnTile() -> Tile
{
    return yellowTurn ? Tile.Yellow : Tile.Red
}

func currentTurnColor() -> UIColor
{
    return yellowTurn ? .systemYellow : .red
}

func currentTurnVictoryMessage() -> String
{
    return yellowTurn ? "Yellow Wins!" : "Red Wins!"
}
