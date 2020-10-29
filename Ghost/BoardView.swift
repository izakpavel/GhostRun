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
        return (x == -1 || y == -1)
    }
    
    var isLastRow: Bool {
        return (x==boardSize || y==boardSize)
    }
    
    var scale: CGFloat {
        return (isFirstRow || isLastRow) ? 0.3 : 1
    }
    
    var opacity: Double {
        return (isFirstRow || isLastRow) ? 0.0 : 1
    }
}

class Board: ObservableObject {
    let size: Int
    var availableSize: CGSize = CGSize() {
        didSet {
            self.adjustTilePositions()
        }
    }
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
        for y in -1..<size+1 {
            for x in -1..<size+1 {
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
                tile.y = tile.y > -1 ? (tile.y - 1) : self.size
            }
            else {
                tile.x = tile.x > -1 ? (tile.x - 1) : self.size
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
            .fill(Color("TileBase"))
            //.overlay(Circle().opacity(tile.hasObject ? 1 : 0))
            //.overlay(Text("\(tile.id)"))
            .frame(width: 58, height: 38)
            .scaleEffect(self.tile.scale)
            .position(self.tile.position)
            .opacity(self.tile.opacity)
            
    }
}


struct BoardView: View {
    @ObservedObject var board = Board(size: 5)
    
    var body: some View {
        GeometryReader { geometry in
            
            let availableSize = CGSize(width: min(geometry.size.width, geometry.size.height), height: 0.666*min(geometry.size.width, geometry.size.height))
            
            ZStack {
                ForEach (self.board.tiles) { tile in
                    TileView(tile: tile)
                }
            }
            .frame(width: availableSize.width, height: availableSize.height)
            .offset(x: (geometry.size.width-availableSize.width)/2, y: (geometry.size.height-availableSize.height)/2)
            .onAppear{
                self.board.availableSize = availableSize
                self.board.start()
            }
        }
    }
}

