//
//  CreateGameController.swift
//  swiftoflife
//
//  Created by Andrew Koprowski on 2/13/18.
//

import Foundation
import PerfectHTTP

protocol GameLogic: class {
}

class GameController: GameLogic {

    // MARK: Object lifecycle
    var request: HTTPRequest
    var response: HTTPResponse
    init(request: HTTPRequest, response: HTTPResponse) {
        self.request = request
        self.response = response
        
        response.addHeader(.accessControlAllowOrigin, value: "*")
        response.addHeader(.accessControlAllowHeaders, value: "Content-Type")
    }
    
    /// Returns a handler which will create a game
    public static func handler(request: HTTPRequest, response: HTTPResponse) {
        let controller = GameController(request: request, response: response)
        controller.createGame(size: 60)
    }
    
    public func createGame(size: Int) {
        var rows: [LifeRow] = []
        for rowNum in 1...size {
            var cells: [LifeCell] = []
            for x in 1...size {
                let cell = LifeCell(x: x, y: rowNum, isAlive: false)
                cells.append(cell)
            }
            let row = LifeRow(size: size, cells: cells, rowNumber: rowNum)
            rows.append(row)
        }
        let game = LifeGrid(size: size, rows: rows)
        render(grid: game)
    }
    
    /// Returns a handler which will create a game
    public static func stepHandler(request: HTTPRequest, response: HTTPResponse) {
        let controller = GameController(request: request, response: response)
        controller.step(json: request.postBodyString ?? "")
    }
    public func step(json: String){
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        var grid = try! decoder.decode(LifeGrid.self, from: data!)
        
        let newGrid = step(grid: &grid, currentState: grid)
        render(grid: newGrid)
    }
    private func step(grid: inout LifeGrid, currentState: LifeGrid) -> LifeGrid{
        for (rowIndex, row) in grid.rows.enumerated() {
            for (cellIndex, cell) in row.cells.enumerated() {
                
                let neighbors = currentState.numberOfNeighbors(x: cell.x, y: cell.y)
                if cell.isAlive {
                    if neighbors <= 1 {
                        // Dies of solitude
                        grid.rows[rowIndex].cells[cellIndex].isAlive = false
                    } else if neighbors >= 4 {
                        // Dies of overpopulation
                        grid.rows[rowIndex].cells[cellIndex].isAlive = false
                    }
                } else {
                    if neighbors == 3 {
                        // Becomes alive
                        grid.rows[rowIndex].cells[cellIndex].isAlive = true
                    }
                }
            }
        }
        return grid
    }
    private func render(grid: LifeGrid) {
    
        // html
        let gameHTML = grid.render()
        // json
        let encoder = JSONEncoder()
        let newData = try! encoder.encode(grid)
        let gameJSON = String(data:newData, encoding: .utf8) ?? "no game"
        
        let resultJSON = "{\"htmlResult\": \"\(gameHTML)\",\"jsonResult\": \(gameJSON)}"
        response.appendBody(string: resultJSON)
        response.completed()
    }
}
