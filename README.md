# TicTacToe
Let's make Tic-Tac-Toe!

# https://github.com/JonnyGamer/TicTacToe

```swift
class GobletPiece {
    let size : Int
    let color : Int
    var covers : GobletPiece?
    
    init(size: Int, color: Int) {
        self.size = size
        self.color = color
    }
    
    func canCover(another: GobletPiece) -> Bool {
        return self.size > another.size
    }
}

class GobletBoard {
    let boardSize : Int
    var board : [[GobletPiece?]]
    
    init(size: Int) {
        self.boardSize = size
        self.board = .init(repeating: .init(repeating: nil, count: boardSize), count: boardSize)
    }
    
    func place(piece: GobletPiece, x: Int, y: Int) -> Bool {
        
        if let willCoverGoblet = board[x][y] {
            if piece.canCover(another: willCoverGoblet) {
                piece.covers = willCoverGoblet
                board[x][y] = piece
                return true
            } else {
                return false
            }
        } else {
            board[x][y] = piece
            return true
        }
        
        return false
    }
}

```
