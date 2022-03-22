//
//  VideoPlayerViewModel.swift
//  MiniPlayer
//
//  Created by Takahiro Tominaga on 2022/03/22.
//

import SwiftUI

class VideoPlayerViewModel: ObservableObject {
    
    // MiniPlayer Properties
    @Published var showPlayer = false
    
    // Gesture Offset
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height: CGFloat = 0
    @Published var isMiniPlayer = false
}
