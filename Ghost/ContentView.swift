//
//  ContentView.swift
//  Ghost
//
//  Created by Pavel Zak on 27/10/2020.
//

import SwiftUI


struct ContentView: View {
    @State var smilePhase: CGFloat = 0.0
    var body: some View {
        VStack {
            BoardView ()
                .frame(width: 100, height: 150)
                .padding()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
