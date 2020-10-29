//
//  ContentView.swift
//  Ghost
//
//  Created by Pavel Zak on 27/10/2020.
//

import SwiftUI

class Game : ObservableObject {
    enum State {
        case intro
        case running
        case finished
    }
    
    var board = Board(size: 5)
    
    @Published var state: State = .intro
    @Published var score: Int = 0
    
    private var currentInterval: Double = 0.4
    
    func isGhostCollision()-> Bool {
        guard let firstTile = self.board.firstTile else {
            return false
        }
        return firstTile.hasObject
    }
    
    func gameStep() {
        withAnimation(Animation.easeIn(duration: self.currentInterval)) {
            self.board.move()
        }
        
        if false {//self.isGhostCollision() {
            self.state = .finished
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + currentInterval) {
                self.gameStep()
            }
        }
        self.currentInterval -= 0.001
    }
    
    func start() {
        self.state = .running
        self.gameStep()
    }
}


struct GameView: View {
    @ObservedObject var game = Game()
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.game.board.directionRight = false
                }) {
                    Image(systemName: "chevron.left.2")
                        .font(.largeTitle)
                        .foregroundColor(Color("TileLight"))
                        .frame(width: 80, height: 160)
                }
                Spacer()
                BoardView (board: self.game.board)
                Spacer()
                Button(action: {
                    self.game.board.directionRight = true
                }) {
                    Image(systemName: "chevron.right.2")
                        .font(.largeTitle)
                        .foregroundColor(Color("TileLight"))
                        .frame(width: 80, height: 160)
                }
                Spacer()
            }
            Text("Score")
                .font(.headline)
                .foregroundColor(Color("TileLight"))
                .padding(.bottom, 20)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .ignoresSafeArea()
        .onAppear{
            self.game.start()
        }
    }
}
