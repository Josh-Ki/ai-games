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
        let uctValues = childNodes.map { node -> Float in
            let exploitationValue = node.value / Float(node.visitCount)
            let explorationValue = sqrt(log(Float(self.visitCount)) / Float(node.visitCount))
            return exploitationValue + explorationFactor * explorationValue
        }
        if uctValues.isEmpty {
            let mostVisitedMove = childNodes.max { $0.visitCount < $1.visitCount }
            return mostVisitedMove?.move ?? gameState.getPossibleMoves().randomElement()!
        }
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
    func currentTurnTile() -> Tile {
        return redTurn ? Tile.Red : Tile.Yellow
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
        print("is win: \(win(player: currentTurnTile()))")
        print("is full: \(boardFull())")
        return win(player: currentTurnTile()) || boardFull() || lose()
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


    func win(player: Tile) -> Bool {
      // Check if the given player has four consecutive tiles in a row, column, or diagonal
      for row in 0..<board.count {
        for col in 0..<board[row].count {
          let tile = board[row][col].tile
          if tile != player {
            continue
          }
          if col + 3 < board[row].count && tile == board[row][col+1].tile && tile == board[row][col+2].tile && tile == board[row][col+3].tile {
            return true // Horizontal win
          }
          if row + 3 < board.count {
            if tile == board[row+1][col].tile && tile == board[row+2][col].tile && tile == board[row+3][col].tile {
              return true // Vertical win
            }
            if col + 3 < board[row].count && tile == board[row+1][col+1].tile && tile == board[row+2][col+2].tile && tile == board[row+3][col+3].tile {
              return true // Diagonal win (bottom-left to top-right)
            }
            if col - 3 >= 0 && tile == board[row+1][col-1].tile && tile == board[row+2][col-2].tile && tile == board[row+3][col-3].tile {
              return true // Diagonal win (top-left to bottom-right)
            }
          }
        }
      }
      return false
    }
    
    func lose() -> Bool {
        // Check if the opponent has won
        
//        let opponentTile = redTurn ? Tile.Yellow : Tile.Red
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
    var maxIterations = 100 // Maximum number of iterations for MCTS algorithm
    let explorationFactor: Float = 1.7 // Exploration factor for UCT algorithm
    var transpositionTable: [String: Node] = [:] // Transposition table to store previously evaluated game states
    var maxDepth = 3
    func findBestMove(gameState: GameState) -> Move {
        print(maxDepth)
        // Create the root node of the search tree
        let rootNode = getNode(for: gameState)
        var bestMove: Move!

                for i in 0..<self.maxIterations {
                    // Selection
                    let nodeToExpand = self.select(node: rootNode)
                    
                    // Expansion
                    let expandedNodes = self.expand(node: nodeToExpand)
                    
                    // Simulation
                    let bestNode = self.simulate(nodes: expandedNodes)
                    
                    // Backpropagation
                    self.backpropagate(node: bestNode)
                    print("iteration \(i)")
                }
                

        
        // Choose the best move based on the UCT value of the child nodes
        bestMove = rootNode.getBestMove(explorationFactor: explorationFactor)
        
        return bestMove
    }

    func getNode(for gameState: GameState) -> Node {
      // Retrieve the node for the given game state from the transposition table, or create a new node if it doesn't exist
      let key = gameState.board.description // Use the board as the key
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
            _ = expand(node: selectedChild)
            return selectedChild
        }
        
        // Recursively select a child node
        return select(node: selectedChild)
    }
    func expand(node: Node) -> [Node] {
      // Create child nodes for the top k possible moves from the current game state
      print("Expanding")
      let possibleMoves = node.gameState.getPossibleMoves()
      var childNodes: [Node] = []
      
      if !possibleMoves.isEmpty {
        
        // Score each possible move using a heuristic function
        let scoredMoves = possibleMoves.map { move -> (Move, Float) in
          print("WE IN ")
          let nextState = node.gameState.makeMove(move)
          let score = evaluateState(nextState)
          print("SCORED MOVE \(score)")
          return (move, score)
        }
        
        // Sort the moves by score in descending order
        let sortedMoves = scoredMoves.sorted { $0.1 > $1.1 }
        print("SORTED MOVES \(sortedMoves)")
        
        // Choose the top k moves,ax
        let k = 6// You can change this value
        let bestMoves = sortedMoves.prefix(k)
        
        // Use a lock to protect the childNodes array from concurrent access
        let lock = NSLock()
        
        // Use DispatchQueue.concurrentPerform to create child nodes in parallel
        DispatchQueue.concurrentPerform(iterations: bestMoves.count) { i in
          let (move, _) = bestMoves[i]
          let childState = node.gameState.makeMove(move)
          let childNode = Node(gameState: childState, move: move, parent: node)
            print(Thread.current)
          
          // Acquire the lock before appending to the array
          lock.lock()
          childNodes.append(childNode)
          lock.unlock()
          
          // print(“Expanded node with move: (move.column), childNodes count: (childNodes.count)”)
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
      print(randomNode.value)
      
      // Use a semaphore to synchronize the access to the simulation result
      let semaphore = DispatchSemaphore(value: 0)
      var simulationResult: Float!
      
      // Use DispatchQueue.global to run the simulation on a background queue
      DispatchQueue.global().async {
          simulationResult = self.simulateRandomPlay(gameState: randomNode.gameState, maxDepth: self.maxDepth)
        randomNode.updateValue(result: simulationResult)
        semaphore.signal()
      }
      
      // Wait for the simulation to finish
      semaphore.wait()
      
      if randomNode.value == -1.0 || randomNode.value == 1.0 {
        // Early stop and propagate the result if the simulation result gives a clear win/loss result
        return randomNode
      }
      
      return randomNode
    }


    func backpropagate(node: Node) {
        // Update the value and visit count of all nodes in the path from the selected node to the root
        print("BackPropgating")
        var currentNode = node
        while let parent = currentNode.parent {
            parent.updateValue(result: currentNode.value)
            currentNode = parent
            
        }
    }


    func simulateRandomPlay(gameState: GameState, maxDepth: Int) -> Float {
      // Simulate a game by playing moves based on a heuristic until the game is over or the max depth is reached
      var currentState = gameState
      var currentDepth = 0
      var aiTurn = true // Keep track of whose turn it is

      while !currentState.isTerminal() && currentDepth < maxDepth {
        let possibleMoves = currentState.getPossibleMoves()

        // Evaluate the desirability of each possible move using a scoring function
        let scoredMoves = possibleMoves.map { move -> (Move, Float) in
          let nextState = currentState.makeMove(move)
          let score = aiTurn ? evaluateState(nextState) : -evaluateState(nextState) // Use different scoring functions for AI and opponent
          return (move, score)
        }

        // Sort the moves by score in descending order
        let sortedMoves = scoredMoves.sorted { $0.1 > $1.1 }

        // Choose the move with the highest score
        let bestMove = sortedMoves.first!.0
        currentState = currentState.makeMove(bestMove)

        // Increment the depth counter
        currentDepth += 1

        // Switch the turn
        aiTurn = !aiTurn
      }

      if currentState.win(player: currentState.currentTurnTile()) {
          print("WIN")
        return 1.0 // AI has won
      } else if currentState.win(player: opposite(tile: currentState.currentTurnTile())) {
          print("LOSE")
        return -1.0 // User has won
      } else {
        // Use the evaluation function to estimate the value of non-terminal state
        return evaluateState(currentState)
      }
    }
    
    func opposite(tile: Tile) -> Tile {
      // Return the opposite tile of the given tile
      if tile == .Red {
        return .Yellow
      } else if tile == .Yellow {
        return .Red
      } else {
        return .Empty
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
      // Evaluate the game state based on the number of possible four-in-a-rows, open-ended four-in-a-rows, and threats for each player
      // A four-in-a-row is a sequence of four consecutive tiles in a row, column, or diagonal
      // A possible four-in-a-row is a four-in-a-row that has at least one empty tile and no opponent tiles
      // An open-ended four-in-a-row is a possible four-in-a-row that has two empty tiles on both ends
      // A threat is a possible four-in-a-row that has three tiles of the same color and one empty tile
      // The more possible four-in-a-rows, open-ended four-in-a-rows, and threats a player has, the higher their chance of winning
      // The value of a possible four-in-a-row depends on how many tiles of the same color it has
      // For example, a possible four-in-a-row with three red tiles and one empty tile has a higher value than one with two red tiles and two empty tiles
      // The value of an open-ended four-in-a-row is higher than the value of a regular possible four-in-a-row
      // The value of a threat is higher than the value of an open-ended four-in-a-row
      // The value of a game state is the sum of the values of all possible four-in-a-rows, open-ended four-in-a-rows, and threats for the AI player minus the sum of the values of all possible four-in-a-rows, open-ended four-in-a-rows, and threats for the opponent player
      // The value ranges from -1.0 (opponent has won) to 1.0 (AI has won)

      let board = state.board
      let aiTile = state.currentTurnTile()
      let opponentTile = opposite(tile: aiTile)

      var aiValue = 0.0 // The value for the AI player
      var opponentValue = 0.0 // The value for the opponent player

      // Loop through all rows, columns, and diagonals and count the number of possible four-in-a-rows, open-ended four-in-a-rows, and threats for each player
      for row in 0..<board.count {
        for col in 0..<board[row].count {

          // Check horizontal four-in-a-rows
          if col + 3 < board[row].count {
            var aiCount = 0 // The number of AI tiles in the four-in-a-row
            var opponentCount = 0 // The number of opponent tiles in the four-in-a-row
            var emptyCount = 0 // The number of empty tiles in the four-in-a-row

            for i in col..<(col + 4) {
              let t = board[row][i].tile
              if t == aiTile {
                aiCount += 1
              } else if t == opponentTile {
                opponentCount += 1
              } else {
                emptyCount += 1
              }
            }

            if emptyCount > 0 && opponentCount == 0 {
              // This is a possible four-in-a-row for the AI player
              if col > 0 && col + 4 < board[row].count && board[row][col - 1].tile == .Empty && board[row][col + 4].tile == .Empty {
                // This is an open-ended four-in-a-row for the AI player
                aiValue += pow(100.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              } else if aiCount == 3 && emptyCount == 1 {
                // This is a threat for the AI player
                aiValue += pow(1000.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              } else {
                // This is a regular possible four-in-a-row for the AI player
                aiValue += pow(10.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              }
            } else if emptyCount > 0 && aiCount == 0 {
              // This is a possible four-in-a-row for the opponent player
              if col > 0 && col + 4 < board[row].count && board[row][col - 1].tile == .Empty && board[row][col + 4].tile == .Empty {
                // This is an open-ended four-in-a-row for the opponent player
                opponentValue += pow(100.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
              } else if opponentCount == 3 && emptyCount == 1 {
                // This is a threat for the opponent player
                opponentValue += pow(1000.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
              } else {
                // This is a regular possible four-in-a-row for the opponent player
                opponentValue += pow(10.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
              }
            }
          }

          // Check vertical four-in-a-rows
          if row + 3 < board.count {
            var aiCount = 0 // The number of AI tiles in the four-in-a-row
            var opponentCount = 0 // The number of opponent tiles in the four-in-a-row
            var emptyCount = 0 // The number of empty tiles in the four-in-a-row

            for i in row..<(row + 4) {
              let t = board[i][col].tile
              if t == aiTile {
                aiCount += 1
              } else if t == opponentTile {
                opponentCount += 1
              } else {
                emptyCount += 1
              }
            }

            if emptyCount > 0 && opponentCount == 0 {
              // This is a possible four-in-a-row for the AI player
              if row > 0 && row + 4 < board.count && board[row - 1][col].tile == .Empty && board[row + 4][col].tile == .Empty {
                // This is an open-ended four-in-a-row for the AI player
                aiValue += pow(100.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              } else if aiCount == 3 && emptyCount == 1 {
                // This is a threat for the AI player
                aiValue += pow(1000.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              } else {
                // This is a regular possible four-in-a-row for the AI player
                aiValue += pow(10.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
              }
            } else if emptyCount > 0 && aiCount == 0 {
              // This is a possible four-in-a-row for the opponent player
              if row > 0 && row + 4 < board.count && board[row - 1][col].tile == .Empty && board[row + 4][col].tile == .Empty {
                // This is an open-ended four-in-a-row for the opponent player
                opponentValue += pow(100.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
              } else if opponentCount == 3 && emptyCount == 1 {
                         // This is a threat for the opponent player
                         opponentValue += pow(1000.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       } else {
                         // This is a regular possible four-in-a-row for the opponent player
                         opponentValue += pow(10.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       }
                     }
                   }

                   // Check diagonal four-in-a-rows (bottom-left to top-right)
                   if row + 3 < board.count && col + 3 < board[row].count {
                     var aiCount = 0 // The number of AI tiles in the four-in-a-row
                     var opponentCount = 0 // The number of opponent tiles in the four-in-a-row
                     var emptyCount = 0 // The number of empty tiles in the four-in-a-row

                     for i in 0..<4 {
                       let t = board[row + i][col + i].tile
                       if t == aiTile {
                         aiCount += 1
                       } else if t == opponentTile {
                         opponentCount += 1
                       } else {
                         emptyCount += 1
                       }
                     }

                     if emptyCount > 0 && opponentCount == 0 {
                       // This is a possible four-in-a-row for the AI player
                       if row > 0 && col > 0 && row + 4 < board.count && col + 4 < board[row].count && board[row - 1][col - 1].tile == .Empty && board[row + 4][col + 4].tile == .Empty {
                         // This is an open-ended four-in-a-row for the AI player
                         aiValue += pow(100.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       } else if aiCount == 3 && emptyCount == 1 {
                         // This is a threat for the AI player
                         aiValue += pow(1000.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       } else {
                         // This is a regular possible four-in-a-row for the AI player
                         aiValue += pow(10.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       }
                     } else if emptyCount > 0 && aiCount == 0 {
                       // This is a possible four-in-a-row for the opponent player
                       if row > 0 && col > 0 && row + 4 < board.count && col + 4 < board[row].count && board[row - 1][col - 1].tile == .Empty && board[row + 4][col + 4].tile == .Empty {
                         // This is an open-ended four-in-a-row for the opponent player
                         opponentValue += pow(100.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       } else if opponentCount == 3 && emptyCount == 1 {
                         // This is a threat for the opponent player
                         opponentValue += pow(1000.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       } else {
                         // This is a regular possible four-in-a-row for the opponent player
                         opponentValue += pow(10.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       }
                     }
                   }

                   // Check diagonal four-in-a-rows (top-left to bottom-right)
                   if row + 3 < board.count && col - 3 >= 0 {
                     var aiCount = 0 // The number of AI tiles in the four-in-a-row
                     var opponentCount = 0 // The number of opponent tiles in the four-in-a-row
                     var emptyCount = 0 // The number of empty tiles in the four-in-a-row

                     for i in 0..<4 {
                       let t = board[row + i][col - i].tile
                       if t == aiTile {
                         aiCount += 1
                       } else if t == opponentTile {
                         opponentCount += 1
                       } else {
                         emptyCount += 1
                       }
                     }

                     if emptyCount > 0 && opponentCount == 0 {
                       // This is a possible four-in-a-row for the AI player
                       if row > 0 && col + 3 < board[row].count && row + 4 < board.count && col - 4 >= 0 && board[row - 1][col + 1].tile == .Empty && board[row + 4][col - 4].tile == .Empty {
                         // This is an open-ended four-in-a-row for the AI player
                         aiValue += pow(100.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       } else if aiCount == 3 && emptyCount == 1 {
                         // This is a threat for the AI player
                         aiValue += pow(1000.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       } else {
                         // This is a regular possible four-in-a-row for the AI player
                         aiValue += pow(10.0, Double(aiCount)) / pow(10.0, Double(emptyCount)) // The value increases with more AI tiles and decreases with more empty tiles
                       }
                     } else if emptyCount > 0 && aiCount == 0 {
                       // This is a possible four-in-a-row for the opponent player
                       if row > 0 && col + 3 < board[row].count && row + 4 < board.count && col - 4 >= 0 && board[row - 1][col + 1].tile == .Empty && board[row + 4][col - 4].tile == .Empty {
                         // This is an open-ended four-in-a-row for the opponent player
                         opponentValue += pow(100.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       } else if opponentCount == 3 && emptyCount == 1 {
                         // This is a threat for the opponent player
                         opponentValue += pow(1000.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       } else {
                         // This is a regular possible four-in-a-row for the opponent player
                         opponentValue += pow(10.0, Double(opponentCount)) / pow(10.0, Double(emptyCount)) // The value increases with more opponent tiles and decreases with more empty tiles
                       }
                     }
                   }
                 }
               }

               let totalValue = aiValue - opponentValue // The total value of the game state

               print("Total Value: \(totalValue)")

               if totalValue >= pow(10.0, Double(4)) {
                 return 1.0 // AI has a guaranteed win
               } else if totalValue <= -pow(10.0, Double(4)) {
                 return -1.0 // Opponent has a guaranteed win
               } else {
                 return Float(totalValue) / Float(pow(10.0, Double(4))) // Normalize the value to be between -1 and 1
               }
             }

         }
