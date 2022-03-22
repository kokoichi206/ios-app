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
    
//    @State private var player: AVPlayer?
    @State private var players: [AVPlayer] = []
    @State private var isPresented = false
    @State private var showingAlert = false
    
    @State private var selectedVideo: AVPlayer?
    @State private var isPlaying = false
    
    @State private var filesManager = FilesManager()
    
    init() {
        
        // ======================= NORMAL TRY ===================================
//        guard let nurl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("movies.MOV") else { return } // 検索するだけなので、createはfalse
//
//        print("url: normal try \(nurl)")
//        do {
//            let readData = try Data(contentsOf: url)
//            let player = AVPlayer(playerItem: AVPlayerItem(a))
//        }
        
//        players = DataManager.readURLs()
        do {
            print("do in init()")
            let url = try filesManager.read(fileNamed: "test")
            print("do in init: url \(url)")
//            players = [AVPlayer(url: try URL(fileURLWithPath: "file:///private/var/mobile/Containers/Shared/AppGroup/D6FDB9FE-ED99-4381-BA6F-F2D0878219B7/File%20Provider%20Storage/photospicker/version=1&uuid=85D1C8D4-CFA0-4817-A6B6-8BA2051B05AE&mode=current.mov"))]
            players = [AVPlayer(url: url)]
            print("completed do in init()")
            print("url: after VideoContentView init() dooo \(players)")
        } catch {
            print("url: ERROR \(error.localizedDescription)")
        }
        print("url: after VideoContentView init() \(players)")
    }
    
    var body: some View {

        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        
//                        if (players.count > 0) {
//                            VideoPlayer(player: players[0])
//                        }
                        
                        ForEach(players, id: \.self) { player in
                            
                            ZStack(alignment: .topLeading) {
                                VideoPlayer(player: player)
                                    .frame(width: self.isPlaying ? .infinity : UIScreen.main.bounds.width, height: 200)
//                                    .onTapGesture(count: 2, perform: {
//                                        self.isPlaying.toggle()
//                                        if (self.isPlaying){
//                                            self.selectedVideo = player
//                                        }
//                                    })
                                
                                Text("full screen!!!!!")
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        self.isPlaying.toggle()
                                        if (self.isPlaying){
                                            selectedVideo = player
                                        }
                                    }
                            }
//                            .frame(width: self.isPlaying ? .infinity : 300, height: 100)
         
                        }
                    }
                }
                .frame(width: .infinity, height: .infinity)
                

                
                Button("tap to show PHPicker") {
                    isPresented.toggle()
                }
                .sheet(isPresented: $isPresented, content: videoPicker)
                
                Button("save remote url file") {
                    do {
                        let url = try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/nn-53.mp4")
                        let data = try Data(contentsOf: url)
                        try filesManager.save(fileNamed: "test", data: data)
                    } catch {
                        
                    }
    //                players = [AVPlayer(url: try URL(fileURLWithPath: "file:///private/var/mobile/Containers/Shared/AppGroup/D6FDB9FE-ED99-4381-BA6F-F2D0878219B7/File%20Provider%20Storage/photospicker/version=1&uuid=85D1C8D4-CFA0-4817-A6B6-8BA2051B05AE&mode=current.mov"))]
    //                print("completed do in init()")
    //                print("url: after VideoContentView init() dooo \(players)")
                }
                
                Button("fetch urls") {
                    fetchURLs()
                }
            }
            
            
            
            // For Full Screen UI
            if (self.isPlaying) {
                
                ZStack(alignment: .topLeading) {
                    VideoPlayer(player: self.selectedVideo)
                        .onTapGesture(count: 2, perform: {
                            self.isPlaying.toggle()
                        })
                    
                    // Why this is NOT WOKRKING ?????????????????
//                    VStack {
//                        Text("Close full screen!!!!!")
//    //                        .background(Color.red)
//                            .foregroundColor(.white)
//                            .offset(x: 15, y: 30)
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        self.isPlaying.toggle()
//                        self.isPlaying = false
//                        print("Close Full Screen...")
//                    }
                       
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(self.isPlaying)
    }
    
    private func videoPicker() -> VideoPicker {
        
        var configuraton = PHPickerConfiguration()
        configuraton.selectionLimit = 1
        configuraton.preferredAssetRepresentationMode = .current
        configuraton.filter = .videos
        
        return VideoPicker(configuration: configuraton,
                           isPresented: $isPresented,
                           players: $players,
                           showingAlert: $showingAlert)
    }
    
    @ViewBuilder
    private func makeFullScreenVideoPlayer(for player: AVPlayer) -> some View {
    VideoPlayer(player: player)
        // 4
        .edgesIgnoringSafeArea(.all)
        .onAppear {
        // 5
            player.play()
        }
    }
    
    private func fetchURLs() {
        do {
//                    let url = try filesManager.read(fileNamed: "test")
//                    print("do in init: url \(url)")
//
//                    players = [AVPlayer(url: url)]
            
            
//                    let hoge = try filesManager.read(fileNamed: "test")
//                    print("urls: \(hoge)")
            
            
//                    players = [AVPlayer(url: try URL(fileURLWithPath: "file:///private/var/mobile/Containers/Shared/AppGroup/D6FDB9FE-ED99-4381-BA6F-F2D0878219B7/File%20Provider%20Storage/photospicker/version=1&uuid=85D1C8D4-CFA0-4817-A6B6-8BA2051B05AE&mode=current.mov"))]
            
            players = [
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/nn-53.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/test-23.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/test2-42.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/1c3736e3-00f3-4abc-88e5-7ee10e28ac11.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/9ae6d820-7d85-45ef-8b2a-43dd9925a15b.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/7530c83e-db10-4ea1-bd6a-22da62da65f7.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/aab22b9c-0754-42c8-91af-70fc7bc0a8c1.mp4")),
                AVPlayer(url: try URL(fileURLWithPath: "https://kokoichi0206.mydns.jp/movie/b075d3db-5a44-4a6f-a84e-071832615b1d.mp4")),
            ]
            self.selectedVideo = players[0]
//                    print("completed do in init()")
//                    print("url: after VideoContentView init() dooo \(players)")
            
        } catch {
            
        }
//                players = [AVPlayer(url: try URL(fileURLWithPath: "file:///private/var/mobile/Containers/Shared/AppGroup/D6FDB9FE-ED99-4381-BA6F-F2D0878219B7/File%20Provider%20Storage/photospicker/version=1&uuid=85D1C8D4-CFA0-4817-A6B6-8BA2051B05AE&mode=current.mov"))]
//                print("completed do in init()")
//                print("url: after VideoContentView init() dooo \(players)")
    }
}

struct PlayerViewController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player =
            AVPlayer(url: Bundle.main.url(forResource: "kawa", withExtension: "mp4")!)
        let controller =  AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        //none
    }
}
