//
//  LifeCell.swift
//  swiftoflife
//
//  Created by Andrew Koprowski on 2/13/18.
//

import Foundation

struct LifeCell:Codable {
    let x: Int
    let y: Int
    var isAlive: Bool
    
    func render() -> String {
        let aliveString = isAlive ? "<div></div>" : ""
        return "<div id='cell_\(x)_\(y)' class='game-cell' onclick='cellClick(this.id)' onmouseover='if(window.gameState.isDragging) cellClick(this.id)'>\(aliveString)</div>"
    }
}
struct LifeRow:Codable {
    let size: Int
    var cells: [LifeCell]
    let rowNumber: Int
    
    func render() -> String {
        var cellsString = ""
        for cell in cells {
            cellsString += cell.render()
        }
        return "<div id='row_\(rowNumber)' class='game-row'>\(cellsString)</div>"
    }
}
struct LifeGrid:Codable {
    let size: Int
    var rows: [LifeRow]
    
    func render() -> String {
        var rowsString = ""
        for row in rows {
            rowsString += row.render()
        }
        return "<div class='game'>\(rowsString)</div>"
    }
    // NOT WORKING
    func numberOfNeighbors(row: Int, col: Int) -> Int {
        var sum = 0
        var rowIndex = row - 1
        var colIndex = col - 1
        
        
        
        for x in -1...1 {
            for y in -1...1 {
                let i = rowIndex + y
                let j = colIndex + x
                if i >= 0 && i < rows.count && j >= 0 && j < rows[i].cells.count && !(y == 0 && x == 0) {
                    if rows[i].cells[j].isAlive {
                        sum += 1
                    }
                }
            }
        }
        return sum
    }
    func numberOfNeighbors(x: Int, y: Int) -> Int {
        var topLeft = 0
        var top = 0
        var topRight = 0
        var left = 0
        var right = 0
        var bottomLeft = 0
        var bottom = 0
        var bottomRight = 0
        
        // Right
        for row in rows where row.rowNumber == y {
            for cell in row.cells where cell.x == x + 1 && cell.isAlive {
                right = 1
            }
        }
        // Bottom
        for row in rows where row.rowNumber == y + 1{
            for cell in row.cells where cell.x == x && cell.isAlive {
                bottom = 1
            }
        }
        // Bottom Right
        for row in rows where row.rowNumber == y + 1{
            for cell in row.cells where cell.x == x + 1 && cell.isAlive {
                bottomRight = 1
            }
        }
        // Bottom Left
        for row in rows where row.rowNumber == y + 1{
            for cell in row.cells where cell.x == x - 1 && cell.isAlive {
                bottomLeft = 1
            }
        }
        // Left
        for row in rows where row.rowNumber == y {
            for cell in row.cells where cell.x == x - 1 && cell.isAlive {
                left = 1
            }
        }
        // Top
        for row in rows where row.rowNumber == y - 1 {
            for cell in row.cells where cell.x == x && cell.isAlive {
                top = 1
            }
        }
        // Top Left
        for row in rows where row.rowNumber == y - 1 {
            for cell in row.cells where cell.x == x - 1 && cell.isAlive {
                topLeft = 1
            }
        }
        // Top Right
        for row in rows where row.rowNumber == y - 1 {
            for cell in row.cells where cell.x == x + 1 && cell.isAlive {
                topRight = 1
            }
        }
        
        // Sum
        return topLeft + top + topRight + left + right + bottomLeft + bottom + bottomRight
    }
}
