//
//  BoardView.swift
//  Ghost
//
//  Created by Pavel Zak on 28/10/2020.
//

import SwiftUI

class Tile : ObservableObject, Identifiable{
    let id: Int
    let boardSize: Int
    var x: Int
    var y: Int
    var hasObject: Bool = false
    @Published var position: CGPoint = CGPoint()
    
    init(x: Int, y: Int, index: Int, boardSize: Int) {
        self.x = x
        self.y = y
        self.id = index
        self.boardSize = boardSize
        
        self.hasObject = Int.random(in: 0..<10)>5
    }
    
    var isFirstRow: Bool {
        return (x==0 || y==0)
    }
    
    var isLastRow: Bool {
        return (x==boardSize-1 || y==boardSize-1)
    }
    
    var scale: CGFloat {
        return (isFirstRow || isLastRow) ? 0.1 : 1
    }
    
    var opacity: Double {
        return (isFirstRow || isLastRow) ? 0.0 : 1
    }
}

class Board: ObservableObject {
    let size: Int
    let availableSize: CGSize = CGSize(width: 300, height: 200)
    @Published var tiles: [Tile]
    var directionRight: Bool = true
    var timer: Timer? = nil
    
    func setTilePosition(_ tile: Tile) {
        let dx = availableSize.width/2/CGFloat(self.size)
        let dy = availableSize.height/2/CGFloat(self.size)
        
        let vx = CGPoint(x: -dx, y: -dy)
        let vy = CGPoint(x: dx, y: -dy)
        
        let a = vx*tile.x
        let b = vy*tile.y
        let c = CGPoint(x: availableSize.width/2, y: availableSize.height-dy)
        tile.position = c + a + b
    }
    
    init(size: Int) {
        self.size = size
        var tiles = [Tile]()
        for y in 0..<size {
            for x in 0..<size {
                let tile = Tile(x: x, y: y, index: tiles.count, boardSize: size)
                tiles.append(tile)
            }
        }
        self.tiles = tiles
        self.adjustTilePositions()
    }
    
    func adjustTilePositions() {
        self.tiles.forEach{ self.setTilePosition($0)}
    }
    
    func move() {
        self.tiles.forEach { tile in
            if (directionRight) {
                tile.y = (tile.y + size - 1)%self.size
            }
            else {
                tile.x = (tile.x + size - 1)%self.size
            }
        }
        self.adjustTilePositions()
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation() {
                self.move()
            }
        }
    }
}

struct TileShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height/2))
            path.addLine(to: CGPoint(x: width/2, y: 0))
            path.addLine(to: CGPoint(x: width, y: height/2))
            path.addLine(to: CGPoint(x: width/2, y: height))
            path.addLine(to: CGPoint(x: 0, y: height/2))
        }
    }
}

struct TileView: View {
    @ObservedObject var tile: Tile
    var body: some View {
        TileShape()
            .stroke(Color.yellow, lineWidth: 4)
            .overlay(Circle().opacity(tile.hasObject ? 1 : 0))
            .overlay(Text("\(tile.id)"))
            .frame(width: 60, height: 40)
            .scaleEffect(self.tile.scale)
            .position(self.tile.position)
            .opacity(self.tile.opacity)
            
    }
}


struct BoardView: View {
    @ObservedObject var board = Board(size: 5)
    
    var body: some View {
        ZStack {
            ForEach (self.board.tiles) { tile in
                TileView(tile: tile)
            }
        }
        .frame(width: 300, height: 200)
        .background(Color.blue)
        .onAppear{
            self.board.start()
        }
    }
}

