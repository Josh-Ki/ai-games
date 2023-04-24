//
//  AI_GamesTests.swift
//  AI GamesTests
//
//  Created by Tony Ngok on 05/02/2023.
//

import XCTest
@testable import boredAI_games

class AI_GamesTests: XCTestCase {
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testEasyBoardGenerated() {
        // Given
        let viewController = SudokuViewController()
        viewController.selectedDifficulty = "Easy"

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertEqual(viewController.sudoku.sudokuArray.count, 9)
        XCTAssertEqual(viewController.sudoku.sudokuArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray.count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.maxCellsToFill, 30)
    }
    func testMediumBoardGenerated() {
        // Given
        let viewController = SudokuViewController()
        viewController.selectedDifficulty = "Medium"

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertEqual(viewController.sudoku.sudokuArray.count, 9)
        XCTAssertEqual(viewController.sudoku.sudokuArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray.count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.maxCellsToFill, 50)
    }
    func testHardBoardGenerated() {
        // Given
        let viewController = SudokuViewController()
        viewController.selectedDifficulty = "Hard"

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertEqual(viewController.sudoku.sudokuArray.count, 9)
        XCTAssertEqual(viewController.sudoku.sudokuArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray.count, 9)
        XCTAssertEqual(viewController.sudoku.partialArray[0].count, 9)
        XCTAssertEqual(viewController.sudoku.maxCellsToFill, 64)
    }

    func testGenerateSudokuBoard() {
           let sudokuVC = SudokuViewController()
           let (board, partialBoard) = sudokuVC.generateSudokuBoard()

           // Test that the board has 81 cells
           XCTAssertEqual(board.count, 9)
           XCTAssertEqual(board.flatMap { $0 }.count, 81)

           // Test that each cell contains a number from 1-9
           XCTAssertTrue(board.flatMap { $0 }.allSatisfy { (1...9).contains($0) })

           // Test that the partial board has the same dimensions as the board
           XCTAssertEqual(partialBoard.count, 9)
           XCTAssertEqual(partialBoard.flatMap { $0 }.count, 81)

           // Test that the partial board has the same number of filled cells as expected
           let expectedFilledCells = (board.flatMap { $0 }.count - partialBoard.flatMap { $0 }.count)
        XCTAssertEqual(expectedFilledCells, sudokuVC.sudoku.maxCellsToFill)

           // Test that each filled cell in the partial board corresponds to a non-zero cell in the board
           for row in 0..<9 {
               for col in 0..<9 {
                   if partialBoard[row][col] != 0 {
                       XCTAssertEqual(partialBoard[row][col], board[row][col])
                   }
               }
           }
        
       }

}
