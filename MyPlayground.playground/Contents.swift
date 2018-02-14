var board = [
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0]
]

func isAlive(x: Int, y: Int) -> Bool {
    if board[y][x] == 1 {
        return true
    } else {
        return false
    }
}

func topLeft(x: Int, y: Int) -> Int {
    let updatedY = y - 1
    let updatedX = x - 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func top(x: Int, y: Int) -> Int {
    let updatedY = y - 1
    let updatedX = x
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func topRight(x: Int, y: Int) -> Int {
    let updatedY = y - 1
    let updatedX = x + 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func right(x: Int, y: Int) -> Int {
    let updatedY = y
    let updatedX = x + 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func bottomRight(x: Int, y: Int) -> Int {
    let updatedY = y + 1
    let updatedX = x + 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func bottom(x: Int, y: Int) -> Int {
    let updatedY = y + 1
    let updatedX = x
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func bottomLeft(x: Int, y: Int) -> Int {
    let updatedY = y + 1
    let updatedX = x - 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func left(x: Int, y: Int) -> Int {
    let updatedY = y
    let updatedX = x - 1
    
    if updatedY >= 0 && updatedY < board.count && updatedX >= 0 && updatedX < board[updatedY].count {
        return board[updatedY][updatedX]
    } else {
        return 0 // as we're out of bounds, so this void is not alive
    }
}

func numberOfAliveNeighbors(x: Int, y: Int) -> Int {
    var aliveNeighbors = 0
    
    aliveNeighbors += topLeft(x: x, y: y)
    aliveNeighbors += top(x: x, y: y)
    aliveNeighbors += topRight(x: x, y: y)
    aliveNeighbors += right(x: x, y: y)
    aliveNeighbors += bottomRight(x: x, y: y)
    aliveNeighbors += bottom(x: x, y: y)
    aliveNeighbors += bottomLeft(x: x, y: y)
    aliveNeighbors += left(x: x, y: y)
    
    return aliveNeighbors
}

func isAliveAfterUnderPopulationRule(x: Int, y: Int) -> Bool {
    if numberOfAliveNeighbors(x: x, y: y) < 2 {
        return false
    } else {
        return true
    }
}

func isAliveAfterSurvivalRule(x: Int, y: Int) -> Bool {
    if numberOfAliveNeighbors(x: x, y: y) == 2 {
        return true
    } else if numberOfAliveNeighbors(x: x, y: y) == 3 {
        return true
    } else {
        return false
    }
}

func isALiveAfterOverpopulationRule(x: Int, y: Int) -> Bool {
    if numberOfAliveNeighbors(x: x, y: y) > 3 {
        return false
    } else {
        return true
    }
}

func isAliveAfterReproductionRule(x: Int, y: Int) -> Bool {
    if numberOfAliveNeighbors(x: x, y: y) == 3 {
        return true
    } else {
        return false
    }
}

func isALiveAfterRules(x: Int, y: Int) -> Bool {
    if isAlive(x: x, y: y) == true {
        if numberOfAliveNeighbors(x: x, y: y) < 2 {
            return isAliveAfterUnderPopulationRule(x: x, y: y)
        } else if numberOfAliveNeighbors(x: x, y: y) == 2 {
            return isAliveAfterSurvivalRule(x: x, y: y)
        } else if numberOfAliveNeighbors(x: x, y: y) == 3 {
            return isAliveAfterSurvivalRule(x: x, y: y)
        } else if numberOfAliveNeighbors(x: x, y: y) > 3{
            return isALiveAfterOverpopulationRule(x: x, y: y)
        }
    } else {
        if isAliveAfterReproductionRule(x: x, y: y) == true {
            return true
        } else {
            return false
        }
    }
    
    return false // should never happen
}

isALiveAfterRules(x: 1, y: 1)
