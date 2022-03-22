//
//  ContentView.swift
//  video-picker
//
//  Created by Takahiro Tominaga on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: ImageContentView()) {
                        Text("Images")
                    }
                    NavigationLink(destination: VideoContentView()) {
                        Text("Videos")
                    }
                }
                .navigationTitle("Picker Sample")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
