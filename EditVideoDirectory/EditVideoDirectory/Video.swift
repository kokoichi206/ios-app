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
    @State private var idx: Int = 0

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if createdURL != nil {
                    // MARK: 動画が作成された後。
                    VStack {
                        Spacer()
                        
                        VideoPlayer(player: player)
                            .onAppear {
                                player = AVPlayer(url: createdURL!)
                                player?.play()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Spacer()
                    }

                } else {
                    // MARK: 動画が作成される前。
                    VStack {
                        Text("Processing")
                    }
                    .padding()
                    .onAppear {
                        // 親動画。
                        let path = Bundle.main.path(forResource: "test", ofType:"MOV")
                        let fileUrl = NSURL(fileURLWithPath: path!)
                        // 加工プロセス。
                        let handler = CreateURLWithRectHandler(url: $createdURL)
                        handler.main(fileUrl: fileUrl as URL)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    // FIXME: 実際にどのように値が送られてくるか調査。
    // 座標の例。
    @State var idxOfFrames: Int = 0

    let coordinates = [
        rectangle(x: 341.0, y: 170.6, width: 580.0, height: 341.0),
        rectangle(x: 370, y: 180.1, width: 580.0, height: 341.0),
        rectangle(x: 470, y: 185.1, width: 580.0, height: 341.0),
        rectangle(x: 341.0, y: 333.3, width: 580.0, height: 341.0),
        rectangle(x: 355, y: 333.6, width: 580.0, height: 341.0),
        rectangle(x: 341.0, y: 333.6, width: 580.0, height: 341.0),
    ]
    
    func main(fileUrl: URL) {
        
        print("main() is called")
        var frames: [UIImage] = []
        let asset = AVURLAsset(url: (fileUrl as URL), options: nil)
        let videoDuration = asset.duration
          
        let generator = AVAssetImageGenerator(asset: asset)
        // 1より細かく刻むには次の2行が必要。
        // https://developer.apple.com/forums/thread/66332
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        
        // FIXME: このフレームレートを30とかにすると次のエラーで落ちる。。。
        // terminated due to memory issue
        // UIImageか何かのメモリを解放する必要がありそう。。。
        let frameRate = 3  // per seconds

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
                        createURLFromImages(uiImages: frames, frameRate: frameRate)
                    }
                }
            }
        })
    }

    func createURLFromImages(uiImages: [UIImage], frameRate: Int) {
        print("time: \(String(describing: time))")
        
        let newImages = uiImages.map { uiImage in
            overlayRectangle(uiImage: uiImage)
        }

        let movie = MovieCreator()
        //16の倍数。
        // 今回の場合はoverlayRectangleで調整しているのでどんなサイズでも良い。
        let movieSize = CGSize(width:320, height:320)

        let movieURL = movie.create(images:newImages, size:movieSize, frameRate:frameRate)
        
        url = movieURL
    }
    
    /*
     UIImageに対して四角形を重ねる。
     */
    func overlayRectangle(uiImage: UIImage) -> UIImage {
        var offsetX = (UIScreen.main.bounds.width) / 2
        var offsetY = (UIScreen.main.bounds.height) / 2

        // FIXME: 計算方法を確立させたい。。。
        let imgWidth = uiImage.size.width
        let imgHeight = uiImage.size.height
        // cgImage.width, cgImage.height
        if (CGFloat(imgWidth) > UIScreen.main.bounds.width) {
            offsetX = 0
            offsetY = (UIScreen.main.bounds.height - CGFloat(imgHeight) * UIScreen.main.bounds.width / CGFloat(imgWidth)) / 2
        } else {
            offsetX = (UIScreen.main.bounds.width - CGFloat(imgWidth)) / 2
            offsetY = 0
        }
        // 動画のサイズの倍率。
        let ratio: CGFloat = UIScreen.main.bounds.width / CGFloat(imgWidth)

        // 四角形をランダムに１つ選び、擬似的に動きをつけている。
        let coordinate = coordinates.randomElement()!
        
        let x = coordinate.x
        let y = coordinate.y
        let rawWidth = coordinate.width
        let rawHeight = coordinate.height

        let startX = offsetX + x * ratio
        let startY = offsetY + y * ratio
        let width = rawWidth * ratio
        let height = rawHeight * ratio
        let lineWidth = 5.0
        
        let videoRect = CGRect(
            x: offsetX, y: offsetY,
            width: UIScreen.main.bounds.width - offsetX,
            height: UIScreen.main.bounds.height - offsetY)

        let maxWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width.truncatingRemainder(dividingBy: 16.0)
        let maxHeight = UIScreen.main.bounds.height - UIScreen.main.bounds.height.truncatingRemainder(dividingBy: 16.0)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxWidth, height: maxHeight))

        let img = renderer.image { context in
            
            // 親画像
            uiImage.draw(in: videoRect)
            
            // FIXME: 計算方法を確立させたい。。。
            // 四角形の描画。座標の計算が難しい。
            let rect = UIBezierPath()
            rect.move(to: CGPoint(x: startX, y: startY))
            rect.addLine(to:CGPoint(x: startX + width, y: startY))
            rect.addLine(to:CGPoint(x: startX + width, y: startY + height))
            rect.addLine(to:CGPoint(x: startX, y: startY + height))
            rect.addLine(to:CGPoint(x: startX, y: startY))
            rect.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = lineWidth
            shapeLayer.fillColor = .none
            shapeLayer.strokeColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            shapeLayer.path = rect.cgPath
            shapeLayer.backgroundColor = UIColor.clear.cgColor
            shapeLayer.render(in: context.cgContext)

        }
        return img
    }
}

/*
 四角形用のstruct
 */
struct rectangle {
    
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}
