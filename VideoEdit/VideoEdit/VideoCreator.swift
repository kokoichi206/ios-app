//
//  VideoCreator.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/07.
//

import UIKit
import AVFoundation


func createVideo(images: [UIImage]) -> URL? {
    
    // 動画にする画像 (R.swift使ってます)
//    let images: [UIImage] = [
//        R.image.dummy_blue()!,
//        R.image.dummy_green()!,
//        R.image.dummy_red()!
//    ]

    // 生成した動画を保存するパス
    let tempDir = FileManager.default.temporaryDirectory
    let previewURL = tempDir.appendingPathComponent("preview.mp4")
    
    // 既にファイルがある場合は削除する
    let fileManeger = FileManager.default
    if fileManeger.fileExists(atPath: previewURL.path) {
        try! fileManeger.removeItem(at: previewURL)
    }
    
    // 最初の画像から動画のサイズ指定する
    var size = images.first!.size
    size = CGSize(width: 320, height: 320)
    
    guard let videoWriter = try? AVAssetWriter(outputURL: previewURL, fileType: AVFileType.mp4) else {
        abort()
    }

    let outputSettings: [String : Any] = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: size.width,
        AVVideoHeightKey: size.height,
    ]
    
    let writerInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
    videoWriter.add(writerInput)
    
    let sourcePixelBufferAttributes: [String:Any] = [
        AVVideoCodecKey: Int(kCVPixelFormatType_32ARGB),
        AVVideoWidthKey: size.width,
        AVVideoHeightKey: size.height
    ]
    let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: writerInput,
        sourcePixelBufferAttributes: sourcePixelBufferAttributes)
    writerInput.expectsMediaDataInRealTime = true
    
//    adaptor.backgroundColor = UIColor.clear
//    writerInput.backgroundColor = UIColor.clear

    // 動画生成開始
    if (!videoWriter.startWriting()) {
        print("Failed to start writing.")
        return nil
    }
    
    videoWriter.startSession(atSourceTime: CMTime.zero)
    
    
    var frameCount: Int64 = 0
    let durationForEachImage: Int64 = 1
    let fps: Int32 = 24
    
    for image in images {
        if !adaptor.assetWriterInput.isReadyForMoreMediaData {
            continue
        }
        
        let colorMasking: [CGFloat] = [0, 50, 0, 50, 0, 50]
        let frameTime = CMTimeMake(value: frameCount * Int64(fps) * durationForEachImage, timescale: fps)
        guard let buffer = pixelBuffer(for: image.cgImage) else {
            continue
        }
        
        if !adaptor.append(buffer, withPresentationTime: frameTime) {
            print("Failed to append buffer. [image : \(image)]")
        }
        
        frameCount += 1
    }
    
    // 動画生成終了
    writerInput.markAsFinished()
    videoWriter.endSession(atSourceTime: CMTimeMake(value: frameCount * Int64(fps) * durationForEachImage, timescale: fps))
    videoWriter.finishWriting {
        print("Finish writing!")
    }
    
    return previewURL
}

func pixelBuffer(for cgImage: CGImage?) -> CVPixelBuffer? {
    guard let cgImage = cgImage else {
        return nil
    }
    
//    let width = cgImage.width
//    let height = cgImage.height
    let width: Int = 320
    let height: Int = 320
    
    let options = [
        kCVPixelBufferCGImageCompatibilityKey: true,
        kCVPixelBufferCGBitmapContextCompatibilityKey: true,
    ] as CFDictionary
    
    var buffer: CVPixelBuffer? = nil
//    CVPixelBufferCreate(kCFAllocatorDefault, width, height,
//                        kCVPixelFormatType_32ARGB, options, &buffer)
    CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                        kCVPixelFormatType_32ARGB, options, &buffer)
    guard let pixelBuffer = buffer else {
        print("nilpo")
        return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
    let pxdata = CVPixelBufferGetBaseAddress(pixelBuffer)
    let rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pxdata,
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * width,
                            space: rgbColorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//    context?.draw(cgImage, in: CGRect(x:0, y:0, width: width, height: height))
//    context?.setFillColor(red: 255, green: 255, blue: 1, alpha: 0)
    
//    context?.drawPath(using: .stroke)
    context?.draw(cgImage, in: CGRect(x:0, y:0, width: width, height: height))
//    context?.setAlpha()
    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
    
    
    return pixelBuffer
}
