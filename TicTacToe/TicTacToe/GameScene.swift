//
//  GameScene.swift
//  TicTacToe
//
//  Created by Jonathan Pappas on 11/3/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var boardSize = 9
    var boardHeight: CGFloat = 568
    var cellSize: CGFloat { boardHeight / CGFloat(boardSize) }
        
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let logo = SKSpriteNode.init(imageNamed: "TicTacToe")
        logo.setScale((90) / logo.size.height)
        logo.position.y = (self.size.height / 2) - 50
        addChild(logo)
        
        var board = SKSpriteNode.init(imageNamed: "3x3Board")
        if boardSize == 4 {
            board = SKSpriteNode.init(imageNamed: "4x4Board")
        }
        if boardSize == 9 {
            board = SKSpriteNode.init(imageNamed: "SuperBoard")
        }
        addChild(board)
        board.setScale((self.size.height - 200) / board.size.height)
        boardHeight = board.size.height
        print(board.size.height)
    }
    
    func tapped(_ pos: CGPoint) -> (x: Int, y: Int) {
        var x = pos.x
        x += cellSize * (CGFloat(boardSize) / 2)
        print(Int(x) / Int(cellSize))
        
        var y = pos.y
        y += cellSize * (CGFloat(boardSize) / 2)
        print(Int(x) / Int(cellSize))
        return ((Int(x) / Int(cellSize)), (Int(y) / Int(cellSize)))
    }
    
    var turn = true
    func addSymbol(_ x: Int,_ y: Int) {
        let s = SKSpriteNode.init(imageNamed: turn ? "x" : "o")
        turn.toggle()
        
        s.setScale((cellSize * 0.5) / s.size.height)
        
        s.position.x = CGFloat(x) * cellSize
        s.position.x -= boardHeight / 2
        s.position.x += cellSize/2
        
        s.position.y = CGFloat(y) * cellSize
        s.position.y -= boardHeight / 2
        s.position.y += cellSize/2
        
        s.name = "\(x) \(y)"
        
        addChild(s)
    }
    
    override func mouseDown(with event: NSEvent) {
        let (x, y) = tapped(event.location(in: self))
        
        // for super board rules
        if boardSize == 9, let (px, py) = previousSpot {
            if (px % 3) == (x % 3), (py % 3) == (y % 3) { return }
        }
        
        // Fixes bug of overlapping on a spot
        if childNode(withName: "\(x) \(y)") == nil {
            previousSpot = (x, y)
            addSymbol(x, y)
        }
    }
    
    var previousSpot: (Int, Int)?
}
