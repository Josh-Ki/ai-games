//
//  AI.swift
//  AI Games
//
//  Created by Joshua Ki on 3/19/23.
//

import Foundation
import UIKit
class Node {
    let gameState: GameState
    let move: Move?
    weak var parent: Node?
    var childNodes: [Node] = []
    var value: Float = 0.0
    var visitCount: Int = 0
    
    init(gameState: GameState, move: Move? = nil, parent: Node? = nil) {
        self.gameState = gameState
        self.move = move
        self.parent = parent
    }
    
    func isLeaf() -> Bool {
        return childNodes.isEmpty
    }
    
    func selectChild(explorationFactor: Float) -> Node {

        // Select the child node with the highest UCT value
        let uctValues = childNodes.map { childNode -> Float in
            let explorationTerm = explorationFactor * sqrt(log(Float(visitCount)) / Float(childNode.visitCount))
            let exploitationTerm = childNode.value / Float(childNode.visitCount)
            return exploitationTerm + explorationTerm
        }
        let maxIndex = uctValues.firstIndex(of: uctValues.max()!)!
        return childNodes[maxIndex]
    }
    
    func updateValue(result: Float) {
        // Update the value and visit count of the node
        value += result
        visitCount += 1
    }
    
    func getBestMove(explorationFactor: Float) -> Move {
        // Choose the move that leads to the child node with the highest UCT value

        // Compute the UCT values for all child nodes
        let uctValues = childNodes.map { node in
            let exploitationValue = node.value / Float(node.visitCount)
            let explorationValue = sqrt(log(Float(self.visitCount)) / Float(node.visitCount))
            return exploitationValue + explorationFactor * explorationValue
        }
        if uctValues.isEmpty {
            // If not, return the move with the highest number of visits
            let mostVisitedMove = childNodes.max { $0.visitCount < $1.visitCount }
            return mostVisitedMove?.move ?? gameState.getPossibleMoves().randomElement()!
        }
        // Choose the move with the highest UCT value
        let bestIndex = uctValues.indices.max { uctValues[$0] < uctValues[$1] }!
        return childNodes[bestIndex].move!
    }

}


class GameState {
    var board: [[BoardItem]]
       var redTurn: Bool
    var hashValue: Int {
            // Generate a hash value based on the state of the game
            var hash = 0
            for row in 0..<6 {
                for col in 0..<7 {
                    let piece = board[row][col].tile
                    if piece == .Empty {
                        hash ^= 0
                    } else if piece == .Red {
                        hash ^= 1
                    } else if piece == .Yellow {
                        hash ^= 2
                    }
                    hash <<= 2
                }
            }
            return hash
        }
       
       init(board: [[BoardItem]], redTurn: Bool) {
           self.board = board
           self.redTurn = redTurn
       }
       
       func makeMove(_ move: Move) -> GameState {
           // Create a new game state with the move applied
           var newBoard = board
           let lowestEmpty = getLowestEmpty(move.column)
           newBoard[lowestEmpty!.column][lowestEmpty!.row] = BoardItem(indexPath: lowestEmpty!.indexPath, tile: currentTurnTile())
           let newState = GameState(board: newBoard, redTurn: !redTurn)
           return newState
       }
    
    func getPossibleMoves() -> [Move] {
        // Return all columns that are not full
        var moves: [Move] = []
        for column in 0..<board[0].count {
            if let _ = getLowestEmpty(column) {
                moves.append(Move(column: column))
            }
        }
        return moves.isEmpty ? [Move(column: 0)] : moves
    }

    func isTerminal() -> Bool {
        // Check if the game is over
        print("is win: \(win())")
        print("is full: \(boardFull())")
        return win() || boardFull() || lose()
    }
    func boardFull() -> Bool {
        // Check if all cells in the board are occupied
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col].tile == .Empty {
                    return false
                }
            }
        }
        return true
    }

    func win() -> Bool {
        // Check if there are four consecutive tiles in a row, column, or diagonal
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                let tile = board[row][col].tile
                if tile == .Empty {
                    continue
                }
                
                if col + 3 < board[row].count &&
                    tile == board[row][col+1].tile &&
                    tile == board[row][col+2].tile &&
                    tile == board[row][col+3].tile {
                    
                    return true // Horizontal win
                }
                if row + 3 < board.count {
                    if tile == board[row+1][col].tile &&
                        tile == board[row+2][col].tile &&
                        tile == board[row+3][col].tile {
                        return true // Vertical win
                    }
                    if col + 3 < board[row].count &&
                        tile == board[row+1][col+1].tile &&
                        tile == board[row+2][col+2].tile &&
                        tile == board[row+3][col+3].tile {
                        return true // Diagonal win (bottom-left to top-right)
                    }
                    if col - 3 >= 0 &&
                        tile == board[row+1][col-1].tile &&
                        tile == board[row+2][col-2].tile &&
                        tile == board[row+3][col-3].tile {
                        return true // Diagonal win (top-left to bottom-right)
                    }
                }
            }
        }
        return false
    }
    
    func lose() -> Bool {
        // Check if the opponent has won
        
        let opponentTile = redTurn ? Tile.Yellow : Tile.Red
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                let tile = board[row][col].tile
                if tile == .Empty || tile == currentTurnTile() {
                    continue
                }
                
                if col + 3 < board[row].count &&
                    tile == board[row][col+1].tile &&
                    tile == board[row][col+2].tile &&
                    tile == board[row][col+3].tile {
                    
                    return true // Opponent has won horizontally
                }
                if row + 3 < board.count {
                    if tile == board[row+1][col].tile &&
                        tile == board[row+2][col].tile &&
                        tile == board[row+3][col].tile {
                        return true // Opponent has won vertically
                    }
                    if col + 3 < board[row].count &&
                        tile == board[row+1][col+1].tile &&
                        tile == board[row+2][col+2].tile &&
                        tile == board[row+3][col+3].tile {
                        return true // Opponent has won diagonally (bottom-left to top-right)
                    }
                    if col - 3 >= 0 &&
                        tile == board[row+1][col-1].tile &&
                        tile == board[row+2][col-2].tile &&
                        tile == board[row+3][col-3].tile {
                        return true // Opponent has won diagonally (top-left to bottom-right)
                    }
                }
            }
        }
        return false
    }

}

class MCTSAI {
    let maxIterations = 10000 // Maximum number of iterations for MCTS algorithm
    let explorationFactor: Float = 1.7 // Exploration factor for UCT algorithm
    let numThreads = 1 // Number of threads to use for parallelization
        let queue = DispatchQueue(label: "com.example.mcts", attributes: .concurrent)
        var transpositionTable: [String: Node] = [:] // Transposition table to store previously evaluated game states
        
        func findBestMove(gameState: GameState) -> Move {
            // Create the root node of the search tree
            let rootNode = getNode(for: gameState)
            var bestMove: Move!
            
            // Run the MCTS algorithm in parallel
            let group = DispatchGroup()
            for _ in 0..<numThreads {
                group.enter()
                queue.async {
                    for _ in 0..<self.maxIterations/self.numThreads {
                        // Selection
                        let nodeToExpand = self.select(node: rootNode)
                        
                        // Expansion
                        let expandedNodes = self.expand(node: nodeToExpand)
                        
                        // Simulation
                        let bestNode = self.simulate(nodes: expandedNodes)
                        
                        // Backpropagation
                        self.backpropagate(node: bestNode)
                    }
                    group.leave()
                }
            }
            group.wait()
            
            // Choose the best move based on the UCT value of the child nodes
            bestMove = rootNode.getBestMove(explorationFactor: explorationFactor)
            
            return bestMove
        }
        
        func getNode(for gameState: GameState) -> Node {
            // Retrieve the node for the given game state from the transposition table, or create a new node if it doesn't exist
            let key = gameState.hashValue.description
            if let node = transpositionTable[key] {
                return node
            } else {
                let node = Node(gameState: gameState)
                transpositionTable[key] = node
                return node
            }
        }
    
    func select(node: Node) -> Node {
//        print("Number of child nodes: \(node.childNodes.count)")
        if node.isLeaf() {
            return node
        }
        
        // Select the child node with the highest UCT value
        let selectedChild = node.selectChild(explorationFactor: explorationFactor)
        
        // Update the visit count of the selected child node
        selectedChild.updateValue(result: 0.0)
        
        if selectedChild.isLeaf() {
            // Expand the selected child node
            expand(node: selectedChild)
            return selectedChild
        }
        
        // Recursively select a child node
        return select(node: selectedChild)
    }

    func expand(node: Node) -> [Node] {
        // Create child nodes for all possible moves from the current game state
        let possibleMoves = node.gameState.getPossibleMoves()
        var childNodes: [Node] = []
        
        if !possibleMoves.isEmpty {

            for move in possibleMoves {

                let childState = node.gameState.makeMove(move)
                let childNode = Node(gameState: childState, move: move, parent: node)
                childNodes.append(childNode)
//                print("Expanded node with move: \(move.column), childNodes count: \(childNodes.count)")

            }
        }
        return childNodes
    }

    
    func simulate(nodes: [Node]) -> Node {
        // Choose a random child node and run a simulation from that state
        let randomIndex = Int.random(in: 0..<nodes.count)
        let randomNode = nodes[randomIndex]
        
        if randomNode.value == -1.0 || randomNode.value == 1.0 {
            // Early stop if the node has already been simulated and has a clear win/loss result
            return randomNode
        }
        
        let simulationResult = simulateRandomPlay(gameState: randomNode.gameState)
        randomNode.updateValue(result: simulationResult)
        
        if randomNode.value == -1.0 || randomNode.value == 1.0 {
            // Early stop and propagate the result if the simulation result gives a clear win/loss result
            return randomNode
        }
        
        return randomNode
    }

    
    func backpropagate(node: Node) {
        // Update the value and visit count of all nodes in the path from the selected node to the root
        var currentNode = node
        while let parent = currentNode.parent {
            parent.updateValue(result: currentNode.value)
            currentNode = parent
            
        }
    }

    
    func simulateRandomPlay(gameState: GameState) -> Float {
        // Simulate a game by playing moves based on a heuristic until the game is over
        var currentState = gameState

        while !currentState.isTerminal() {
            let possibleMoves = currentState.getPossibleMoves()

            // Evaluate the desirability of each possible move using a scoring function
            let scoredMoves = possibleMoves.map { move in
                let nextState = currentState.makeMove(move)
                let score = evaluateState(nextState)
                return (move, score)
            }

            // Sort the moves by score in descending order
            let sortedMoves = scoredMoves.sorted { $0.1 > $1.1 }

            // Choose the move with the highest score
            let bestMove = sortedMoves.first!.0
            currentState = currentState.makeMove(bestMove)
        }

        if currentState.win() {
            print("WON")
            return 1.0
        } else if currentState.lose() {
            print("LOSE")
            return -1.0
        } else {
            return 0.0
        }
    }
    func evaluateState(_ state: GameState) -> Float {
            // Retrieve the value of the given game state from the transposition table, or evaluate it if it hasn't been seen before
            let key = state.hashValue.description
            if let node = transpositionTable[key] {
                return node.value
            } else {
                let value = evaluateStateWithoutTranspositionTable(state)
                let node = getNode(for: state)
                node.updateValue(result: value)
                return value
            }
        }
        
        func evaluateStateWithoutTranspositionTable(_ state: GameState) -> Float {
            // Evaluate the desirability of a game state using a scoring function
            // Same as before
            return Float.random(in: 0...1)
        }

        
    




}
