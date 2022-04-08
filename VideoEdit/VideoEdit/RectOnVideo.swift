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

struct rectangle {
    
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
}

struct PlayerView: UIViewRepresentable {
    
    var url_: URL
    
    init(url: URL) {
        url_ = url
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    func makeUIView(context: Context) -> UIView {
//        let rectUrl = movieTest(offsetX: 0.0, offsetY: 0.0, ratio: 1.0)
        let image = UIImage(named: "cat.png")!

        let movie = MovieCreator()
        //16の倍数
        let movieSize = CGSize(width:320, height:320)
        // time / 60 秒表示する
        let time = AVURLAsset(url: url_).duration.seconds

        let coordinates = [
            rectangle(x: 341.0, y: 170.6, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 180.1, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 185.1, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.3, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.6, width: 580.0, height: 341.0),
            rectangle(x: 341.0, y: 333.6, width: 580.0, height: 341.0),
        ]

        var imageArray: [UIImage] = [image, image, image, image, image, image, image, image, image]
        
        //動画を生成
//        let movieURL = movie.create(images:imageArray, size:movieSize, time:Int(time))
//        print("movieURL: \(movieURL)")
        
        let movieURL = movieTest(url: url_, coordinates: coordinates)
        
        return PlayerUIView(frame: .zero, url: url_, rectUrl: movieURL)
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
//        print(offsetX)
//        print(offsetY)
        
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

    init(frame: CGRect, url: URL, rectUrl: URL) {
        super.init(frame: frame)
        
        // メインの動画。
        player = AVPlayer(url: url)
        player.play()
        playerLayer.player = player
        layer.addSublayer(playerLayer)

        // 四角形のレイヤー。
        rectPlayer = AVPlayer(url: rectUrl)
        rectPlayer.play()
        rectPlayerLayer.player = rectPlayer
        layer.addSublayer(rectPlayerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        rectPlayerLayer.frame = bounds
    }
}

extension UIImage {
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
        layer.isOpaque, UIScreen.main.scale)
//        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
//                                               false, UIScreen.main.scale)

        defer { UIGraphicsEndImageContext() }

        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

func movieTest(url: URL, coordinates: [rectangle]) -> URL {
    var offsetX = (UIScreen.main.bounds.width) / 2
    var offsetY = (UIScreen.main.bounds.height) / 2
  
    
    var ratio: CGFloat = 0.0
    
    var parentWidth = 0.0
    var parentHeight = 0.0

    // 親が全画面である必要がある
    let track = AVPlayer(url: url).currentItem?.asset.tracks(withMediaType: .video).first
    if let track = track {
        let trackSize = track.naturalSize

        print("===== track =====")
        print(trackSize)
        parentWidth = trackSize.width
        parentHeight = trackSize.height
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
    
    var imageArray: [UIImage] = []
    
    for coordinate in coordinates {
        print(parentWidth)
        let x = coordinate.x
        let y = coordinate.y
        let rawWidth = coordinate.width
        let rawHeight = coordinate.height

        let startX = offsetX + x * ratio
        let startY = offsetY + y * ratio
//        let startX = 0.0
//        let startY = 0.0
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
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        
//        var renderer = UIGraphicsImageRenderer(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let format = UIGraphicsImageRendererFormat.default()
        
        // α
        format.opaque = true

        var renderer = UIGraphicsImageRenderer(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), format: format)

        var image = renderer.image { context in
//            draw(image: frame, in: context.cgContext)
            context.cgContext.clear(shapeLayer.bounds)
            

//            let size = renderer.format.bounds.size
//            UIColor.white.withAlphaComponent(0).setFill()
//            context.cgContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            return shapeLayer.render(in: context.cgContext)
                
            //            shapeLayer.render(in: context.cgContext)
            //            UIGraphicsGetImageFromCurrentImageContext()
            //            for _ in 0...50 {
            //                let rect = CGRect(
            //                    x: .random(in: 0...300),
            //                    y: .random(in: 0...600),
            //                    width: .random(in: 50...100),
            //                    height: .random(in: 50...100)
            //                )
            //
            //                let color = UIColor(
            //                    red: .random(in: 0...1),
            //                    green: .random(in: 0...1),
            //                    blue: .random(in: 0...1),
            //                    alpha: 1.0
            //                )
            //                color.setFill()
            //                context.cgContext.fillEllipse(in: rect)
            //            }
        }
//        image.withBackground(color: UIColor.clear)
        
        image = UIImage(named: "cat.png")!
        
        let colorMasking: [CGFloat] = [0, 50, 0, 50, 0, 50]
        print(image.cgImage!)
        guard let cgImage = image.cgImage?.copy(maskingColorComponents: colorMasking) else {
            print("nilnil")
            continue }

        let returnImage = UIImage(cgImage: cgImage)
//        let cgImage = image.cgImage?.copy(maskingColorComponents: colorMasking)
//        print(cgImage)
//        image = UIImage(cgImage: cgImage!)
//        image = image.copy(maskingColorComponents: colorMasking) as! UIImage
//        print(returnImage.cgImage!)
//        imageArray.append(contentsOf: [returnImage])
        // チェック用！
//        imageArray.append(contentsOf: [UIImage(named: "cat.png")!])
        imageArray.append(contentsOf: [returnImage])
    }
    
//    image = UIImage(named: "cat.png")!

    let movie = MovieCreator()
    //16の倍数
    let movieSize = CGSize(width:320, height:320)
    // time / 60 秒表示する
    let time = 600

    //動画を生成
    let movieURL = movie.create(images:imageArray,size:movieSize,time:time)
    print("movieURL: \(movieURL)")
            
//    let track = AVURLAsset(url: movieURL).tracks(withMediaType: AVMediaType.video).first
//    if track != nil {
//        let size = track?.naturalSize.applying(track!.preferredTransform)
//        print("dims of created movie:")
//        print(size)
//        print("duration of created movie: \(AVURLAsset(url: movieURL).duration.seconds)")
//        print("")
//    }
    
    return createVideo(images: imageArray)!
//    return movieURL
}

extension UIImage {
  func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
    guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
    defer { UIGraphicsEndImageContext() }
        
    let rect = CGRect(origin: .zero, size: size)
    ctx.setFillColor(color.cgColor)
    ctx.fill(rect)
    ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
    ctx.draw(image, in: rect)
        
    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }
}


struct RectOnVideo_Previews: PreviewProvider {
    static var previews: some View {
        RectOnVideo()
    }
}
