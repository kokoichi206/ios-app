//
//  RectOnVideo.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/01.
//

import SwiftUI
import AVKit

var player = AVPlayer()

struct RectOnVideo: View {
    
    var moviePath: URL = Bundle.main.url(forResource: "test", withExtension: "MOV")!
    
    var body: some View {
        ZStack {
            // ここが全画面である必要がある！
            PlayerView(url: moviePath)

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

class PlayerUIView: UIView {
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
        
        // 親が全画面である必要がある
        let track = player.currentItem?.asset.tracks(withMediaType: .video).first
        if let track = track {
            let trackSize = track.naturalSize
            let videoViewSize = playerLayer.bounds.size
            playerLayer.bounds
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
        }
    
        print("===== offset =====")
        print(offsetX)
        print(offsetY)

        
//        // Rectangle
//        let rectFrame: CGRect = CGRect(x:CGFloat(0), y:CGFloat(0), width:CGFloat(100), height:CGFloat(50))

//        // Create a UIView object which use above CGRect object.
//        let greenView = UIView(frame: rectFrame)
//
//        // Set UIView background color.
//        greenView.backgroundColor = UIColor.green
//
//        layer.addSublayer(greenView.layer)
        
        let startX = offsetX + 100
        let startY = offsetY + 50
        let width = 170.0
        let height = 100.0
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
        // 線の色
//        UIColor.gray.setStroke()
//        line.lineWidth = lineWidth
//        line.stroke()
        
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



struct RectOnVideo_Previews: PreviewProvider {
    static var previews: some View {
        RectOnVideo()
    }
}
