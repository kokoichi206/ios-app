//
//  VideoController.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/01.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class VideoController: UIViewController {
    var _assetExport: AVAssetExportSession!

    //動画のマージ処理をするメソッド
    func mergeMovie() {
        //元の動画のURLを取得
        let baseMovieURL = self.getBaseMovieURL()

        //アセットの作成
        //動画のアセットとトラックを作成
        var videoAsset: AVURLAsset
        var videoTrack: AVAssetTrack
        var audioTrack: AVAssetTrack

        videoAsset = AVURLAsset(url: baseMovieURL, options:nil)
        let videoTracks = videoAsset.tracks(withMediaType: AVMediaType.video)
        videoTrack = videoTracks[0]   //トラックの取得
        let audioTracks = videoAsset.tracks(withMediaType: AVMediaType.audio)
        audioTrack = audioTracks[0]   //トラックの取得

        //コンポジション作成
        let mixComposition : AVMutableComposition = AVMutableComposition()
        // ベースとなる動画のコンポジション作成
        let compositionVideoTrack: AVMutableCompositionTrack! = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        // ベースとなる音声のコンポジション作成
        let compositionAudioTrack: AVMutableCompositionTrack! = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)

        // コンポジションの設定
        // 動画の長さ設定
        try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoTrack, at: CMTime.zero)
        // 音声の長さ設定
        try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioTrack, at: CMTime.zero)
        // 回転方向の設定
        compositionVideoTrack.preferredTransform = videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform

        // 動画のサイズを取得
        let videoSize: CGSize = videoTrack.naturalSize

        // 合成用コンポジション作成
        let videoComp: AVMutableVideoComposition = AVMutableVideoComposition()
        videoComp.renderSize = videoSize
        videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)

        // インストラクションを合成用コンポジションに設定
        let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)
        let layerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: compositionVideoTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComp.instructions = [instruction]

        // 動画のコンポジションをベースにAVAssetExportを生成
        _assetExport = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        // 合成用コンポジションを設定
        _assetExport?.videoComposition = videoComp

        // エクスポートファイルの設定
        let exportPath: String = NSHomeDirectory() + "/tmp/createdMovie.mov"
        let exportUrl: URL = URL(fileURLWithPath: exportPath)
        _assetExport?.outputFileType = AVFileType.mov
        _assetExport?.outputURL = exportUrl
        _assetExport?.shouldOptimizeForNetworkUse = true

        // ファイルが存在している場合は削除
        if FileManager.default.fileExists(atPath: exportPath) {
            try! FileManager.default.removeItem(atPath: exportPath)
        }

        // エクスポート実行
        _assetExport?.exportAsynchronously(completionHandler: {() -> Void in
            if self._assetExport?.status == AVAssetExportSession.Status.failed {
                // 失敗した場合
                print("failed:", self._assetExport?.error)
            }
            if self._assetExport?.status == AVAssetExportSession.Status.completed {
                // 成功した場合
                print("completed")
                // カメラロールに保存
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
                })
            }
        })
    }

    //元の動画の取得
    func getBaseMovieURL() -> URL {
        // プロジェクト入れたファイルはこれで取得可能
        let baseMovieURL:URL = Bundle.main.bundleURL.appendingPathComponent("basemovie.mov")
        return baseMovieURL
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mergeMovie()
    }
}
