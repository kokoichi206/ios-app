//
//  ContentView.swift
//  FastingTimer
//
//  Created by Takahiro Tominaga on 2022/01/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // MARK: Background
            
            Color(#colorLiteral(red: 0.03641154245, green: 0.005049427971, blue: 0.06040825695, alpha: 1))
                .ignoresSafeArea()
            
            content
        }
    }
    
    var content: some View {
        VStack {
            // MARK: Progress Ring
            
            ProgressRing()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
