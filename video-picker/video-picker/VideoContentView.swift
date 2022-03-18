//
//  VideoContentView.swift
//  video-picker
//
//  Created by Takahiro Tominaga on 2022/03/18.
//

import SwiftUI
import AVKit
import PhotosUI

struct VideoContentView: View {
    
    @State private var player: AVPlayer?
    @State private var isPresented = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            
        }
        VStack {
            Spacer(minLength: 50)
                .fixedSize()

            ZStack {
                VideoPlayer(player: player)

                Rectangle()
                    .onTapGesture {
                        isPresented.toggle()
                    }
                    .foregroundColor(.black)
                    .opacity(player != nil ? 0 : 1.0)
            }
            
            Spacer(minLength: 20)
                .fixedSize()
            
            Button("tap to show PHPicker") {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented, content: videoPicker)
            
            Spacer(minLength: 50)
                .fixedSize()
        }
    }
    
    private func videoPicker() -> VideoPicker {
        
        var configuraton = PHPickerConfiguration()
        configuraton.selectionLimit = 1
        configuraton.preferredAssetRepresentationMode = .current
        configuraton.filter = .videos
        
        return VideoPicker(configuration: configuraton,
                           isPresented: $isPresented,
                           player: $player,
                           showingAlert: $showingAlert)
    }
}
