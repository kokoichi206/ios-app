//
//  Video.swift
//  EditVideoDirectory
//
//  Created by Takahiro Tominaga on 2022/04/08.
//

import SwiftUI
import AVKit
import UIKit

struct RectOnVideo: View {
    
    var moviePath: URL = Bundle.main.url(forResource: "test", withExtension: "MOV")!
    @State var player: AVPlayer? = nil
    @State var createdURL: URL? = nil
    @State var images: [UIImage]? = nil
    @State private var idx: Int = 0

    var body: some View {
        ZStack {
            GeometryReader { geometry in
//                if createdURL != nil {
//                    VideoPlayer(player: player)
//                        .onAppear {
//                            player = AVPlayer(url: createdURL!)
//                            player?.play()
//                        }
//                        .background(Color.green)
//                } else {
//                    VStack {
//                        Text("Hoge")
//                    }
//                    .padding()
//                    .onAppear {
//                        let path = Bundle.main.path(forResource: "test", ofType:"MOV")
//                        let fileUrl = NSURL(fileURLWithPath: path!)
//                        let handler = CreateURLWithRectHandler(url: $createdURL)
//                        handler.main(fileUrl: fileUrl as URL)
//        //                player = AVPlayer(url: fileUrl as URL)
//                    }
//                }
                if images != nil {
                    Image(uiImage: images![idx])
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("hoge")
                        .onAppear {
                            let path = Bundle.main.path(forResource: "test", ofType:"MOV")
                            let fileUrl = NSURL(fileURLWithPath: path!)
                            let handler = CreateURLWithRectHandler(url: $createdURL, images: $images)
                            handler.main(fileUrl: fileUrl as URL)
            //                player = AVPlayer(url: fileUrl as URL)
                        }
                }
            }
            HStack {
                Button {
                    idx -= 1
                } label: {
                    Text("subt idx")
                }
                Spacer()
                Text("idx: \(idx)")
                Spacer()
                Button {
                    idx += 1
                } label: {
                    Text("add idx")
                }
            }
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

struct CreateURLWithRectHandler {
    @Binding var url: URL?
    @Binding var images: [UIImage]?
    
    func main(fileUrl: URL) {
        
        print("test() is called")
        var frames: [UIImage] = []
        let asset = AVURLAsset(url: (fileUrl as URL), options: nil)
        let videoDuration = asset.duration
          
        let generator = AVAssetImageGenerator(asset: asset)
        // 1より細かく刻むには次の2行が必要。
        // https://developer.apple.com/forums/thread/66332
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        
        let frameRate = 30  // per seconds

        var frameForTimes = [NSValue]()
        let sampleCounts = Int(videoDuration.seconds * Double(frameRate))

        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let step = totalTimeLength / sampleCounts
      
        for i in 0 ..< sampleCounts {
            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }
      
        generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
            DispatchQueue.main.async {
                if let image = image {
    //                    print(requestedTime.value, requestedTime.seconds, actualTime.value)
                    frames.append(UIImage(cgImage: image))
//                    print(frames.count)
                    // TODO: この条件式で良い？
                    if (frames.count == sampleCounts) {
                        createURLFromImages(images: frames, frameRate: frameRate)
                        images = frames
                    }
                }
            }
        })
    }

    func createURLFromImages(images: [UIImage], frameRate: Int) {
        print("time: \(time)")

        let movie = MovieCreator()
        //16の倍数
        let movieSize = CGSize(width:320, height:320)

        let coordinates = [
            rectangle(x: 341.0, y: 170.6, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 180.1, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 185.1, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.3, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.6, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.6, width: 580.0, height: 341.0),
        ]
        
        let movieURL = movie.create(images:images, size:movieSize, frameRate:frameRate)
        
        url = movieURL
    }
}

struct rectangle {
    
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}
