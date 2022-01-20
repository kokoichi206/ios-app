//
//  ContentView.swift
//  TinderClone
//
//  Created by Gary Tokman on 2/15/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                CardView(proxy: proxy)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
