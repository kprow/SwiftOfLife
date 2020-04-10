---
date: 2020-04-05 14:39
description: Conway's Game of Life written in swift. Project write up.
tags: project, swift, server side
---
# Swift of Life

John Conway, a british mathematician, invented a not so typical game in 1970 that is still in heavy use today. He invented the [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). Some say it is the most often programmed computer game in existence. In practice, it is a simple set of rules acting on an initial state to determine it's next state.


<img class="left" alt="Glider Gun in Conway's Game of Life" src="/images/swift-of-life/glider_gun.gif" />

It is a [cellular automaton](https://en.wikipedia.org/wiki/Cellular_automaton) which is just a grid of `cells` that have a state of on or off, or in Conway's Game of Life they indicate dead or alive. In 1968 Conway began experimenting with a variety of different `rules` to govern 2D cellular automaton. He tried many possibilities that caused cells to die too fast, or rules that cause too many cells to be born. He had some challenging goals where an initial state could last a long time before dying, and also wanted other configurations to go on forever without allowing cycles. He also wanted the rules to be as simple as possible, that allowed no explosive growth, and unpredictable outcomes.

The rules for the Conway's Game of Life are as follows:

1. Any LIVE cell with FEWER than 2 LIVE neighbors DIES (simulating underpopulation).
2. Any LIVE cell with 2 or 3 LIVE neighbors LIVES on to the next generation (simulating survival).
3. Any LIVE cell with MORE than 3 LIVE neighbors DIES (simulating overpopulation).
4. Any DEAD cell with EXACTLY 3 LIVE neighbors becomes a LIVE cell (simulating reproduction).

With these simple rules, I can see why people enjoy programming these in their language of choice. And the thought intrigued me as well.


So, I decided to do it in my preferred language Swift. My main purpose was to use Swift outside of the iOS / macOS ecosystem. In this case, I used [Perfect](https://perfect.org/) as my framework for server side logic. This was my first time using the Swift language on the server side of things. How exciting! Furthermore, this project ended up incorporating much of my web development experience by using html and css to render the game state, and javascript to control game state and stepping through states.

My goal was for the game's logic to be written in Swift, So, I decided to create 3 objects to model the game.

* `LifeCell` is an object that represents one cell, this has it's own x, y coordinate, as well as a boolean `isAlive` to convey its state of on or off.

```
struct LifeCell:Codable {
    let x: Int
    let y: Int
    var isAlive: Bool
    
    func render() -> String {
        // Render a div if this cell is alive. Or blank if this cell is dead.
        let aliveString = isAlive ? "<div></div>" : ""
        return "<div id='cell_\(x)_\(y)' class='game-cell'>\(aliveString)</div>"
    }
}
```

* `LifeRow` is an object that represents rows that make up the grid. This contains individual cells. It also contains a size attribute, and row number to index its self with in a grid. 

```
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
```

* `LifeGrid` is a grid that is the cellular automaton, this main game object which contains rows. It also has a size attribute (currently only supports square grids).

```
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
}
```

As you can see each of these objects contains a render function that returns the HTML representation of themselves. Furthermore, if you call the `render()` method on an instance of `LifeGrid` the entire game will be rendered in html.

Now that we have the basic Swift object to represent the game, we need to program the rules of the game. All of the rules depend on how many neighboring cells are either alive or dead. So, let's come up with a helper object that finds neighboring cells within a grid, I will call it `NeighborFinder` and it should have a focus cell defined by an (x, y) coordinate system, and the grid itself.

Also note that every cell interacts with its eight neighbors, so to get some use out of our `NeighborFinder` we will need 8 methods for finding neighbors. And each of these methods should return a `LifeCell` so we can check its state(`isAlive` is true or false). The eight method signatures (organized by starting at the top and going clockwise) should look like this:

```
protocol NeighborFinderProtocol {
    func getTop() -> LifeCell?
    func getTopRight() -> LifeCell?
    func getRight() -> LifeCell?
    func getBottomRight() -> LifeCell?
    func getBottom() -> LifeCell?
    func getBottomLeft() -> LifeCell?
    func getLeft() -> LifeCell?
    func getTopLeft() -> LifeCell?
}
```

Note that if any of the neighboring cells are off grid the find method will return nil.

In order to easily find neighbors, I found it simple to create indexes for easy access of different rows and cells. Here is my implementation.

```
struct NeighborFinder: NeighborFinderProtocol {
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
    ...
}
```

So the actual protocol methods are implemented like this:

```
    ...

    func getTop() -> LifeCell? {
        if topIndex >= 0 && topIndex < rows.count && colIndex >= 0 && colIndex < rows[topIndex].cells.count {
            return rows[topIndex].cells[colIndex]
        }
        return nil
    }

    func getTopRight() -> LifeCell? {
        if topIndex >= 0 && topIndex < rows.count && rightIndex >= 0 && rightIndex < rows[topIndex].cells.count {
            return rows[topIndex].cells[rightIndex]
        }
        return nil
    }
    ...
```

After all of this setup work is complete we can just need one last helper method to tie it all together. A method that counts the number of neighbors using the `NeighborFinder` defined above. In my case, I decided to add it to the `LifeGrid` object, so it can use `self` and an (x,y) coordinate to evaluate a certain cell.

```
 func numberOfNeighbors(x: Int, y: Int) -> Int {
        var sum = 0
        let neighbors = NeighborFinder(grid: self, focusX: x, focusY: y)
        
        // Right
        if let right = neighbors.getRight(), right.isAlive {
            sum += 1
        }
        // Bottom
        if let bottom = neighbors.getBottom(), bottom.isAlive {
            sum += 1
        }
        // Bottom Right
        if let bottomRight = neighbors.getBottomRight(), bottomRight.isAlive {
            sum += 1
        }
        // Bottom Left
        if let bottomLeft = neighbors.getBottomLeft(), bottomLeft.isAlive {
            sum += 1
        }
        // Left
        if let left = neighbors.getLeft(), left.isAlive {
            sum += 1
        }
        // Top
        if let top = neighbors.getTop(), top.isAlive {
            sum += 1
        }
        // Top Left
        if let topLeft = neighbors.getTopLeft(), topLeft.isAlive {
            sum += 1
        }
        // Top Right
        if let topRight = neighbors.getTopRight(), topRight.isAlive {
            sum += 1
        }
        return sum
    }
```

Finally, after all this grunt work, we can program Conway's Game of Life rules. And the best part about it, in my opinion, is how readable the final code can be. Please compare the following code snippet to the 4 written rules at the top.

```
func step(grid: inout LifeGrid, currentState: LifeGrid) -> LifeGrid{
    // Enumerate through each cell in the grid
    for (rowIndex, row) in grid.rows.enumerated() {
        for (cellIndex, currentCell) in row.cells.enumerated() {
            // Find the number of alive neighbors of the current cell
            let aliveNeighbors = currentState.numberOfNeighbors(x: currentCell.x, y: currentCell.y)
            if currentCell.isAlive {
                if aliveNeighbors <= 1 {
                    // 1. Simulates underpopulation
                    grid.rows[rowIndex].cells[cellIndex].isAlive = false
                } else if aliveNeighbors >= 4 {
                    // 3. Simulates of overpopulation
                    grid.rows[rowIndex].cells[cellIndex].isAlive = false
                } else {
                    // 2. Simulates survival
                    grid.rows[rowIndex].cells[cellIndex].isAlive = true
                }
            } else {
                // 4. Simulates reproduction
                if aliveNeighbors == 3 {
                    grid.rows[rowIndex].cells[cellIndex].isAlive = true
                }
            }
        }
    }
    return grid
}
```

The step method simulated the next game state, or next generation. It enumerats and traverses each cell, then we find the current's cell and the number of alive neighbors it has, then we compute the rules of the game. This really is as simple as it gets. And that's why I love this example of cellular automata. These 4 simple rules have been around for 50 years, and mathematicians, computer programmers and thinkers all over the world are still discovering neat patterns and evolving the subject.

### What's next

The code snippets above is just some of the code used to implement this game. Most of the CSS, and Javascript has been stripped out. To see the whole project please visit the public [GitHub repository](https://github.com/kprow/SwiftOfLife/tree/master/Sources).

In the past this was hosted on AWS, and I used the [Perfect Assistant](https://perfect.org/en/assistant/) to deploy this. It was an impressively easy deployment, however, it did cost some money to run those servers, so, I did not leave it up indefinitely. If you would like to see it action please reach out to me, and I can look into deploying it again.

Some of the implementation in this project is incomplete and could use improvement. For example, my version only supports a square grid. Supporting different grid shapes would be a good feature. Also, my version has an edge where Conway's Game of Life is supposed to be infinite. There are some programming tricks to make it appear infinite, however, I decided not to implement this at this time. Feel free to fork the repository and any features you wish.

Thanks for reading. Please let me know how you liked it. This is my first project write up, and I hope it reflects my passion for the Swift language and server side development.


### 🤘🏾Love Life
