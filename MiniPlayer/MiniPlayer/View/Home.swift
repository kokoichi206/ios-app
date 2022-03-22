//
//  Home.swift
//  MiniPlayer
//
//  Created by Takahiro Tominaga on 2022/03/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var player = VideoPlayerViewModel()
    
    // Gesture State to avoid Drag Gesture Glitches...
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView{
                
                VStack(spacing: 15) {
                    
                    ForEach(videos){video in
                        
                        VideoCardView(video: video)
                            .onTapGesture {
                                withAnimation {
                                    player.showPlayer.toggle()
                                }
                            }
                    }
                }
            }
            
            // Video Player View....
            if player.showPlayer{
                MiniPlayer()
                    .transition(.move(edge: .bottom))
                    .offset(y: player.offset)
                    .gesture(
                        DragGesture()
                            .updating($gestureOffset, body: { value, state, _ in
                                state = value.translation.height
                            })
                            .onEnded(onEnd(value: )))
            }
        }
        .onChange(of: gestureOffset) { value in
            onChanged()
        }
        .environmentObject(player)
    }
    
    func onChanged() {
        
        if gestureOffset >= 0 && !player.isMiniPlayer && player.offset + 70 <= player.height {
            withAnimation(.default) {
                player.offset = gestureOffset
                
                if player.offset > 300 {
                    player.offset = 0
                    player.isMiniPlayer = false
                    player.showPlayer = false
                }
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.default){

            if !player.isMiniPlayer{
                
                player.offset = 0
                
                if value.translation.height > UIScreen.main.bounds.height / 3 {
                    player.isMiniPlayer = true
                } else {
                    player.isMiniPlayer = false
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
