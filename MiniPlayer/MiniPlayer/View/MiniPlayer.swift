//
//  MiniPlayer.swift
//  MiniPlayer
//
//  Created by Takahiro Tominaga on 2022/03/22.
//

import SwiftUI

struct MiniPlayer: View {
    var body: some View {
        
        VStack(spacing: 0) {
            GeometryReader{reader in
                
                VStack(spacing: 18, ){
                    Text("M1 MacBook Unboxing And First Impressions")
                }
            }
        }
        .background(
        
            Color.white
                .ignoresSafeArea(.all, edges: .all)
        )
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
