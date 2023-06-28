//
//  ViewController.swift
//  SecureTest
//
//  Created by Takahiro Tominaga on 2022/09/30.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var secureView: UIView!
    @IBOutlet weak var textView: UIView?

    private lazy var playerItem: AVPlayerItem = {
        guard let url = Bundle.main.url(forResource: "test", withExtension: "mp4") else {
            fatalError("test.mp4 not found.")
        }
        return AVPlayerItem(url: url)
    }()
    
    private lazy var queuePlayer: AVQueuePlayer = {
        return AVQueuePlayer(playerItem: playerItem)
    }()

    private var playerLooper: AVPlayerLooper? = nil

    @IBOutlet weak var secureMovieView: MovieView! {
        didSet {
            secureMovieView.addPlayer(queuePlayer: queuePlayer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        secureView.makeSecure()
        
        

//        textView?.makeSecure()
        
//        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
//        queuePlayer.play()
//
//        NotificationCenter.default.addObserver(
//            forName: UIApplication.willEnterForegroundNotification,
//            object: nil,
//            queue: .main
//        ) { [weak self] _ in
//            if self?.queuePlayer.timeControlStatus == .paused {
//                self?.queuePlayer.play()
//            }
//        }
    }
}

final class MovieView: UIView {
    private lazy var playerLayer = { AVPlayerLayer() }()
    
    func addPlayer(queuePlayer: AVQueuePlayer) {
        makeSecure()
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
         playerLayer.frame = bounds
     }
}

extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}
