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
    func numberOfNeighbors(x: Int, y: Int) -> Int {
        var sum = 0
        
        let rowIndex = y - 1
        let colIndex = x - 1
        
        let rightIndex = colIndex + 1
        let leftIndex = colIndex - 1
        let topIndex = rowIndex - 1
        let bottomIndex = rowIndex + 1
        
        // Right
        if rowIndex >= 0 && rowIndex < rows.count && rightIndex >= 0 && rightIndex < rows[rowIndex].cells.count {
            if rows[rowIndex].cells[rightIndex].isAlive {
                sum += 1
            }
        }
        // Bottom
        if bottomIndex >= 0 && bottomIndex < rows.count && colIndex >= 0 && colIndex < rows[bottomIndex].cells.count {
            if rows[bottomIndex].cells[colIndex].isAlive {
                sum += 1
            }
        }
        // Bottom Right
        if bottomIndex >= 0 && bottomIndex < rows.count && rightIndex >= 0 && rightIndex < rows[bottomIndex].cells.count {
            if rows[bottomIndex].cells[rightIndex].isAlive {
                sum += 1
            }
        }
        // Bottom Left
        if bottomIndex >= 0 && bottomIndex < rows.count && leftIndex >= 0 && leftIndex < rows[bottomIndex].cells.count {
            if rows[bottomIndex].cells[leftIndex].isAlive {
                sum += 1
            }
        }
        // Left
        if rowIndex >= 0 && rowIndex < rows.count && leftIndex >= 0 && leftIndex < rows[rowIndex].cells.count {
            if rows[rowIndex].cells[leftIndex].isAlive {
                sum += 1
            }
        }
        // Top
        if topIndex >= 0 && topIndex < rows.count && colIndex >= 0 && colIndex < rows[topIndex].cells.count {
            if rows[topIndex].cells[colIndex].isAlive {
                sum += 1
            }
        }
        // Top Left
        if topIndex >= 0 && topIndex < rows.count && leftIndex >= 0 && leftIndex < rows[topIndex].cells.count {
            if rows[topIndex].cells[leftIndex].isAlive {
                sum += 1
            }
        }
        // Top Right
        if topIndex >= 0 && topIndex < rows.count && rightIndex >= 0 && rightIndex < rows[topIndex].cells.count {
            if rows[topIndex].cells[rightIndex].isAlive {
                sum += 1
            }
        }
        return sum
    }
}
