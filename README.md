# TicTacToe
Let's make Tic-Tac-Toe!

# https://github.com/JonnyGamer/TicTacToe

```swift
class GameScene: SKScene {
    var gobletGame = GobletGame.init(players: 2, size: 4)
    
    var boardSize = 4
    var boardHeight: CGFloat = 568
    var cellSize: CGFloat { boardHeight / CGFloat(boardSize) }
    let turnCounter = SKLabelNode.init(text: "foo Turn")
    var pieceSize = 4
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let board = SKSpriteNode.init(imageNamed: "4x4Board")
        addChild(board)
        board.setScale((self.size.height - 200) / board.size.height)
        boardHeight = board.size.height
        print(board.size.height)
        
        addChild(turnCounter)
        turnCounter.fontColor = .black
        turnCounter.fontName = "SF Compact Rounded"
        turnCounter.position.y = -self.size.height / 2 + 30
        
        updateText()
    }
    
    func tapped(_ pos: CGPoint) -> (x: Int, y: Int) {
        var x = pos.x
        x += cellSize * (CGFloat(boardSize) / 2)
        print(Int(x) / Int(cellSize))
        
        var y = pos.y
        y += cellSize * (CGFloat(boardSize) / 2)
        return ((Int(x) / Int(cellSize)), (Int(y) / Int(cellSize)))
    }
    
    func addSymbol(_ x: Int,_ y: Int, piece: GobletPiece?) {
        childNode(withName: "\(x) \(y)")?.removeFromParent()
        guard let piece = piece else { return }
        
        let s = SKShapeNode.init(circleOfRadius: boardHeight/2)
        s.fillColor = gobletGame.turnColor(color: piece.color)
        
        s.setScale( CGFloat(piece.size) * (cellSize * 0.5) / (s.frame.size.height * 4))
        
        s.position.x = CGFloat(x) * cellSize
        s.position.x -= boardHeight / 2
        s.position.x += cellSize/2
        
        s.position.y = CGFloat(y) * cellSize
        s.position.y -= boardHeight / 2
        s.position.y += cellSize/2
        
        s.name = "\(x) \(y)"
        
        addChild(s)
    }
    
    var willMovePiece: (x: Int, y: Int, goblet: GobletPiece)? // Step 2.
    
    override func mouseDown(with event: NSEvent) {
        let (x, y) = tapped(event.location(in: self))
        if x >= 4 || x < 0 { return }
        if y >= 4 || y < 0 { return }
        
        if willMovePiece == nil, let piece = gobletGame.board.board[x][y] {
            if piece.color != gobletGame.turn { return }
            childNode(withName: "\(x) \(y)")?.alpha = 0.5
            willMovePiece = (x, y, piece)
            updateText()
            return
        }
        
        if let w = willMovePiece {
            let underneath = w.goblet.covers
            if gobletGame.board.move(fromX: w.x, fromY: w.y, toX: x, toY: y, color: gobletGame.turn) {
                addSymbol(x, y, piece: w.goblet)
                addSymbol(w.x, w.y, piece: underneath)
                gobletGame.nextTurn()
                willMovePiece = nil
            }
        } else {
            if gobletGame.willPlayPiece(size: pieceSize) {
                let willPlay = GobletPiece.init(size: pieceSize, color: gobletGame.turn)
                if gobletGame.board.place(piece: willPlay, x: x, y: y) {
                    addSymbol(x, y, piece: willPlay)
                    gobletGame.nextTurn()
                    willMovePiece = nil
                }
            }
        }
        
        updateText()
        
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123 {
            pieceSize -= 1
            if pieceSize < 1 { pieceSize = 1 }
        } else if event.keyCode == 124 {
            pieceSize += 1
            if pieceSize > 4 { pieceSize = 4 }
        } else if event.keyCode == 51, let w = willMovePiece {
            willMovePiece = nil
            childNode(withName: "\(w.x) \(w.y)")?.alpha = 1
        }
        updateText()
    }
    
    func updateText() {
        turnCounter.text = "\(gobletGame.turnName())'s Turn"
        
        if gobletGame.board.didWin(team: 0) {
            turnCounter.text = "White Wins!"
            return
        } else if gobletGame.board.didWin(team: 1) {
            turnCounter.text = "Black Wins!"
            return
        }
        
        if let w = willMovePiece {
            turnCounter.text! += " / Selected [\(w.x), \(w.y)]"
        } else {
            turnCounter.text! += " / Size \(pieceSize)"
            turnCounter.text! += " / Available \(gobletGame.availablePieces(size: pieceSize))"
        }
    }
}
```
