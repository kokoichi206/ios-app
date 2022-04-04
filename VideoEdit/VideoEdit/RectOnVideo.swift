//
//  RectOnVideo.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/01.
//

import SwiftUI
import AVKit
import UIKit

class ViewController: UIViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()

    //画面の向きが変わったことを通知する
     NotificationCenter.default.addObserver(
          self,
          selector: #selector(self.changedOrientation),
          name: UIDevice.orientationDidChangeNotification,
          object: nil)
      
  }

  // 画面の向きが変わった時に呼ばれる
   @objc func changedOrientation() {
      print("画面の向きが変わった")
  }
}

var player = AVPlayer()
var rectPlayer = AVPlayer()

struct RectOnVideo: View {
    
    var moviePath: URL = Bundle.main.url(forResource: "test", withExtension: "MOV")!
    @State var isVertical = true
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    if (isVertical) {
                        // ここが全画面である必要がある！
                        PlayerView(url: moviePath)
                            .background(.gray)
                            
                    } else {
                        // ここが全画面である必要がある！
                        PlayerView(url: moviePath)
                            .background(.red)
                    }
                }
                .onChange(of: geometry.size.width) { newValue in
                    isVertical = UIDevice.current.orientation.rawValue == 1
                }
            }


            VStack {
                Spacer()
                
                Button(action: {
                    player.rate = 0.04
                }, label: {
                    Text("Play Slow")
                })
            }
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

struct PlayerView: UIViewRepresentable {
    
    var url_: URL
    
    init(url: URL) {
        url_ = url
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, url: url_)
    }
}

struct PlayerViewPortrait: UIViewRepresentable {
    
    var url_: URL
    
    init(url: URL) {
        url_ = url
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerViewPortrait>) {
    }
    func makeUIView(context: Context) -> UIView {
        return PlayerUIViewPortrait(frame: .zero, url: url_)
    }
}

class PlayerUIViewPortrait: UIView {
    private let playerLayer = AVPlayerLayer()
    
    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        
        player = AVPlayer(url: url)
        player.play()
        
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        // 完全に中央揃えになってる場合（TODO: 要チェック）
        print("UIScreen ")
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height)
        print(playerLayer.videoRect.width)
        print(playerLayer.frame.height)
        
        var offsetX = (UIScreen.main.bounds.width - playerLayer.frame.width) / 2
        var offsetY = (UIScreen.main.bounds.height - playerLayer.frame.height) / 2
        
        
        var ratio: CGFloat = 0.0
        
        // 親が全画面である必要がある
        let track = player.currentItem?.asset.tracks(withMediaType: .video).first
        if let track = track {
            let trackSize = track.naturalSize
            let videoViewSize = playerLayer.bounds.size

            print("===== track =====")
            print(trackSize)
            print(trackSize.width)
            print(trackSize.height)
            print(videoViewSize)
            // TODO: fix this calc
            if (trackSize.width > UIScreen.main.bounds.width) {
                offsetX = 0
                offsetY = (UIScreen.main.bounds.height - trackSize.height * UIScreen.main.bounds.width / trackSize.width) / 2
            } else {
                offsetX = (UIScreen.main.bounds.width - trackSize.width) / 2
                offsetY = 0
            }
            ratio = UIScreen.main.bounds.height / trackSize.height
        }
    
        print("===== offset =====")
        print(offsetX)
        print(offsetY)
        
        let x = 341.0
        let y = 170.6
        let rawWidth = 580.0
        let rawHeight = 341.0

        let startX = offsetX + x * ratio
        let startY = offsetY + y * ratio
        let width = rawWidth * ratio
        let height = rawHeight * ratio
        let lineWidth = 5.0
        // 線
        let line = UIBezierPath()
        line.move(to: CGPoint(x: startX, y: startY))
        line.addLine(to:CGPoint(x: startX + width, y: startY))
        line.addLine(to:CGPoint(x: startX + width, y: startY + height))
        line.addLine(to:CGPoint(x: startX, y: startY + height))
        line.addLine(to:CGPoint(x: startX, y: startY))
        // 終わる
        line.close()

        print(startX)
        print(startY)
        print(ratio)
        
        let rect = CAShapeLayer()
        rect.lineWidth = lineWidth
        rect.fillColor = .none
        rect.strokeColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        rect.path = line.cgPath
        
        layer.addSublayer(rect)
        
//        print(player.currentTime())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private let rectPlayerLayer = AVPlayerLayer()

    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        
        print("the duration of main movie")
        print(AVURLAsset(url: url).duration.seconds)

//        player = AVPlayer(url: url)
//        player.play()
//
//        playerLayer.player = player
//        layer.addSublayer(playerLayer)
        // 完全に中央揃えになってる場合（TODO: 要チェック）
        print("UIScreen ")
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height)
        print(playerLayer.videoRect.width)
        print(playerLayer.frame.height)
        
//        var offsetX = (UIScreen.main.bounds.width - playerLayer.frame.width) / 2
//        var offsetY = (UIScreen.main.bounds.height - playerLayer.frame.height) / 2
//
        var offsetX = (UIScreen.main.bounds.width) / 2
        var offsetY = (UIScreen.main.bounds.height) / 2
      
        
        var ratio: CGFloat = 0.0

        // 親が全画面である必要がある
        let track = player.currentItem?.asset.tracks(withMediaType: .video).first
        if let track = track {
            let trackSize = track.naturalSize
            let videoViewSize = playerLayer.bounds.size

            print("===== track =====")
            print(trackSize)
            print(trackSize.width)
            print(trackSize.height)
            print(videoViewSize)
            // TODO: fix this calc
            if (trackSize.width > UIScreen.main.bounds.width) {
                offsetX = 0
                offsetY = (UIScreen.main.bounds.height - trackSize.height * UIScreen.main.bounds.width / trackSize.width) / 2
            } else {
                offsetX = (UIScreen.main.bounds.width - trackSize.width) / 2
                offsetY = 0
            }
            ratio = UIScreen.main.bounds.width / trackSize.width
        }
    
        print("===== offset =====")
        print(offsetX)
        print(offsetY)

        let rectUrl = movieTest(offsetX: offsetX, offsetY: offsetY, ratio: ratio)
        print("rectUrl: \(rectUrl)")

        rectPlayer = AVPlayer(url: rectUrl)
        print(rectUrl)

        Thread.sleep(forTimeInterval: 1)

        rectPlayer.play()
        print("size of rectPlayer")

        rectPlayerLayer.player = rectPlayer
        print(rectPlayer.currentTime())
        print(rectPlayer.currentItem?.asset.tracks(withMediaType: .video))
        print(rectPlayerLayer.frame.width)

        layer.addSublayer(rectPlayerLayer)

        
//        // Rectangle
//        let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(0), width:CGFloat(100), height:CGFloat(50))

//        // Create a UIView object which use above CGRect object.
//        let greenView = UIView(frame: rectFrame)
//
//        // Set UIView background color.
//        greenView.backgroundColor = UIColor.green
//
//        layer.addSublayer(greenView.layer)

        
//        layer.addSublayer(rect)
        
//        print(player.currentTime())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    func movieTest(offsetX: CGFloat, offsetY: CGFloat, ratio: CGFloat) -> URL {
        let x = 341.0
        let y = 170.6
        let rawWidth = 580.0
        let rawHeight = 341.0

//        let startX = offsetX + x * ratio
//        let startY = offsetY + y * ratio
        let startX = x * ratio
        let startY = y * ratio
        let width = rawWidth * ratio
        let height = rawHeight * ratio
        let lineWidth = 5.0
        
        // 線
        let rect = UIBezierPath()
        rect.move(to: CGPoint(x: startX, y: startY))
        rect.addLine(to:CGPoint(x: startX + width, y: startY))
        rect.addLine(to:CGPoint(x: startX + width, y: startY + height))
        rect.addLine(to:CGPoint(x: startX, y: startY + height))
        rect.addLine(to:CGPoint(x: startX, y: startY))
        // 終わる
        rect.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = .none
        shapeLayer.strokeColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        shapeLayer.path = rect.cgPath

//        let diameter: CGFloat = 100
//        let rect = CGRect(origin: CGPoint.zero,
//                          size: CGSize(width: diameter, height: diameter))
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.lineWidth = 10
//        shapeLayer.path = CGPath(ellipseIn: rect,
//                                 transform: nil)
        
//        let image = UIImage.imageWithLayer(layer: rect)
//        let image = UIImage.image(from: rect)

        var renderer = UIGraphicsImageRenderer(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        let renderer = UIGraphicsImageRenderer(size: rect.size)
         renderer = UIGraphicsImageRenderer(size: CGSize(width: 320, height: 320))
             
        var image = renderer.image {
            context in
            print("renderer.image")

            return shapeLayer.render(in: context.cgContext)
        }
        
        image = UIImage(named: "cat.png")!

        let movie = MovieCreator()
        //16の倍数
        let movieSize = CGSize(width:320, height:320)
        // time / 60 秒表示する
        let time = 6009

        var imageArray: [UIImage] = [image, image, image, image, image, image, image, image, image]
//        if image != nil {
//            imageArray = [image!]
//            print("imageArray: \(imageArray)")
//        } else {
//            print("imageArray: image is nil")
//        }
        
        //動画を生成
        let movieURL = movie.create(images:imageArray,size:movieSize,time:time)
        print("movieURL: \(movieURL)")
        
//        Thread.sleep(forTimeInterval: 1000)
        
        print("end of sleep, WAKE UP!!")
        
        let track = AVURLAsset(url: movieURL).tracks(withMediaType: AVMediaType.video).first
        if track != nil {
            let size = track?.naturalSize.applying(track!.preferredTransform)
            print("dims of created movie:")
            print(size)
            print("duration of created movie:")
            print(AVURLAsset(url: movieURL).duration.seconds)
            print("")
        }
        
        return movieURL
    }
}

//extension UIImage {
//    class func imageWithLayer(layer: CALayer) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
//        layer.render(in: UIGraphicsGetCurrentContext())
//        let img = UIGraphicsGetImageFromCurrentImageContext() ?? nil
//        UIGraphicsEndImageContext()
//        return img!
//    }
//}
extension UIImage {
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
        layer.isOpaque, UIScreen.main.scale)

        defer { UIGraphicsEndImageContext() }

        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



struct RectOnVideo_Previews: PreviewProvider {
    static var previews: some View {
        RectOnVideo()
    }
}
