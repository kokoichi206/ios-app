//
//  Home.swift
//  MiniPlayer
//
//  Created by Takahiro Tominaga on 2022/03/22.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView{
                
                VStack(spacing: 15) {
                    
                    ForEach(videos){video in
                        
                        VideoCardView(video: video)
                    }
                }
            }
            
            // Video Player View....
            MiniPlayer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
