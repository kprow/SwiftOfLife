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
        let counter = NeigbhorCounter(grid: self, focusX: x, focusY: y)
        
        // Right
        if let right = counter.getRight(), right.isAlive {
            sum += 1
        }
        // Bottom
        if let bottom = counter.getBottom(), bottom.isAlive {
            sum += 1
        }
        // Bottom Right
        if let bottomRight = counter.getBottomRight(), bottomRight.isAlive {
            sum += 1
        }
        // Bottom Left
        if let bottomLeft = counter.getBottomLeft(), bottomLeft.isAlive {
            sum += 1
        }
        // Left
        if let left = counter.getLeft(), left.isAlive {
            sum += 1
        }
        // Top
        if let top = counter.getTop(), top.isAlive {
            sum += 1
        }
        // Top Left
        if let topLeft = counter.getTopLeft(), topLeft.isAlive {
            sum += 1
        }
        // Top Right
        if let topRight = counter.getTopRight(), topRight.isAlive {
            sum += 1
        }
        return sum
    }
}
struct NeigbhorCounter {
    let grid: LifeGrid
    let focusX: Int
    let focusY: Int
    
    var rows: [LifeRow] {
        return grid.rows
    }
    
    var rowIndex:Int {
        return focusY - 1
    }
    var colIndex:Int {
        return focusX - 1
    }
    
    var rightIndex: Int {
        return colIndex + 1
    }
    var leftIndex : Int {
        return  colIndex - 1
    }
    var topIndex : Int {
        return  rowIndex - 1
    }
    var bottomIndex : Int {
        return  rowIndex + 1
    }
    func getRight() -> LifeCell? {
        if rowIndex >= 0 && rowIndex < rows.count && rightIndex >= 0 && rightIndex < rows[rowIndex].cells.count {
            return rows[rowIndex].cells[rightIndex]
        }
        return nil
    }
    func getBottom() -> LifeCell? {
        if bottomIndex >= 0 && bottomIndex < rows.count && colIndex >= 0 && colIndex < rows[bottomIndex].cells.count {
            return rows[bottomIndex].cells[colIndex]
        }
        return nil
    }
    func getBottomRight() -> LifeCell? {
        if bottomIndex >= 0 && bottomIndex < rows.count && rightIndex >= 0 && rightIndex < rows[bottomIndex].cells.count {
            return rows[bottomIndex].cells[rightIndex]
        }
        return nil
    }
    func getBottomLeft() -> LifeCell? {
        if bottomIndex >= 0 && bottomIndex < rows.count && leftIndex >= 0 && leftIndex < rows[bottomIndex].cells.count {
            return rows[bottomIndex].cells[leftIndex]
        }
        return nil
    }
    func getLeft() -> LifeCell? {
        if rowIndex >= 0 && rowIndex < rows.count && leftIndex >= 0 && leftIndex < rows[rowIndex].cells.count {
            return rows[rowIndex].cells[leftIndex]
        }
        return nil
    }
    func getTop() -> LifeCell? {
        if topIndex >= 0 && topIndex < rows.count && colIndex >= 0 && colIndex < rows[topIndex].cells.count {
            return rows[topIndex].cells[colIndex]
        }
        return nil
    }
    func getTopLeft() -> LifeCell? {
        if topIndex >= 0 && topIndex < rows.count && leftIndex >= 0 && leftIndex < rows[topIndex].cells.count {
            return rows[topIndex].cells[leftIndex]
        }
        return nil
    }
    func getTopRight() -> LifeCell? {
        if topIndex >= 0 && topIndex < rows.count && rightIndex >= 0 && rightIndex < rows[topIndex].cells.count {
            return rows[topIndex].cells[rightIndex]
        }
        return nil
    }
}
