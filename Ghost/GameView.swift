//
//  ContentView.swift
//  Ghost
//
//  Created by Pavel Zak on 27/10/2020.
//

import SwiftUI

class Game : ObservableObject {
    var board = Board(size: 5)
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
    }
}
