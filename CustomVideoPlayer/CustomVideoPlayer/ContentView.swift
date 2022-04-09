//
//  ContentView.swift
//  CustomVideoPlayer
//
//  Created by Takahiro Tominaga on 2022/04/10.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                player(url: URL(string: "https://kokoichi0206.mydns.jp/movie/nn-53.mp4")!)
                    .frame(
                        height: UIDevice.current.orientation.isLandscape ? geo.size.height : geo.size.height / 3)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct player: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController {
        
        let player1 = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player1
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}
