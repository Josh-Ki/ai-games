//
//  BoardItem.swift
//  AI Games
//
//  Created by Joshua Ki on 2/21/23.
//
//MARK: Struct for a boarditem
import Foundation
import UIKit
enum Tile: String {
    case Red = "R"
    case Yellow = "Y"
    case Empty = "E"
}


struct BoardItem {
    var indexPath: IndexPath!
    var tile: Tile!
    var row: Int { return indexPath.row }
    var column: Int { return indexPath.section }
    
    func yellowTile() -> Bool { return tile == Tile.Yellow }
    func redTile() -> Bool { return tile == Tile.Red }
    func emptyTile() -> Bool { return tile == Tile.Empty }
    
    func tileColor() -> UIColor {
        if redTile() { return .red }
        if yellowTile() { return .systemYellow }
        return .white
    }
    
    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "indexPathRow": indexPath.row,
            "indexPathSection": indexPath.section,
            "tile": tile.rawValue
        ]
        return dict
    }

    
}
struct Move {
    let column: Int
}
