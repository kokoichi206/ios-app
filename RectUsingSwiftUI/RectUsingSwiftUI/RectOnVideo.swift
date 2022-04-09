//
//  RectOnVideo.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/01.
//

import SwiftUI
import AVKit
import UIKit
import Combine

struct rectangle {

    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}

let coordinates = [
    rectangle(x: 341.0, y: 170.6, width: 211, height: 111),
    rectangle(x: 341.0, y: 180.1, width: 190, height: 88),
    rectangle(x: 244, y: 185.1, width: 197, height: 108),
    rectangle(x: 252, y: 333.3, width: 190, height: 122),
    rectangle(x: 287, y: 180.1, width: 180, height: 144),
    rectangle(x: 312, y: 333.6, width: 170, height: 333),
    rectangle(x: 341.0, y: 170.6, width: 160, height: 180),
    rectangle(x: 341.0, y: 180.1, width: 211, height: 145),
    rectangle(x: 244, y: 185.1, width: 144, height: 99),
    rectangle(x: 252, y: 333.3, width: 209, height: 124),
    rectangle(x: 287, y: 180.1, width: 133, height: 111),
    rectangle(x: 312, y: 333.6, width: 211, height: 105),
]

let _url = Bundle.main.url(forResource: "test", withExtension: "MOV")!
struct RectOnVideo: View {

//    let player = AVPlayer(url: _url)
    let totalTime = AVURLAsset(url: _url).duration.seconds

//    @State var rectPos: rectangle = coordinates[0]
//    @EnvironmentObject var rectPos: rectangle = coordinates[0]
    @StateObject var updaterViewModel = UpdaterViewModel(player: AVPlayer(url: _url))

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    if #available(iOS 15.0, *) {
                        VideoPlayer(player: updaterViewModel.player)
                            .background(.gray)
                            .onAppear {
                                updaterViewModel.player.play()
//                                sleep(1)
//                                while player.currentTime().seconds < totalTime {
//                                    print(player.currentTime().seconds)
//                                    rectPos = calculatePosition(timeSec: player.currentTime().seconds)
//                                    print(rectPos)
//                                }
//                                sleep(30)
                            }
//                            .onTapGesture {
//                                if player.currentTime().seconds == totalTime {
//                                    player.seek(to: CMTime(value: 0, timescale: 30))
//                                    player.play()
//                                } else {
//                                    while player.currentTime().seconds < totalTime {
//                                       print(player.currentTime().seconds)
//                                       rectPos = calculatePosition(timeSec: player.currentTime().seconds)
//                                       print(rectPos)
//                                   }
//                                }
//                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .onTapGesture {
//                    if player.currentTime().seconds == totalTime {
//                        player.seek(to: CMTime(value: 0, timescale: 30))
//                        player.play()
//                    } else {
//                        // State オブジェクトの更新タイミングがわからない。。。
//                        while player.currentTime().seconds < totalTime {
//                           print(player.currentTime().seconds)
//                           rectPos = calculatePosition(timeSec: player.currentTime().seconds)
//                           print(rectPos)
//                       }
//                        print(rectPos)
//                    }
                }
            }

            if updaterViewModel.pos != nil {
                Rectangle()
                    .stroke(Color.blue, lineWidth: 5)
                    .frame(width: updaterViewModel.pos!.width, height: updaterViewModel.pos!.height)
                    .offset(x: 10, y: 20)
            }
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

class UpdaterViewModel: ObservableObject {
    @Published var pos: rectangle? = coordinates[0]
    let interval: Double = 1 / 10
    var player: AVPlayer

    var timer: Timer?
    init(player: AVPlayer) {
        self.player = player
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            self.refresh(timeSec: player.currentTime().seconds)
        })
    }
    deinit {
        timer?.invalidate()
    }
    func refresh(timeSec: Double) {
        pos = calculatePosition(timeSec: timeSec)
    }
}

/*
 与えられた時間から四角形の位置を計算する
 */
func calculatePosition(timeSec: Double) -> rectangle {
    return coordinates.randomElement()!
}
