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
        
        BoardView ()
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(Color("Background"))
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
