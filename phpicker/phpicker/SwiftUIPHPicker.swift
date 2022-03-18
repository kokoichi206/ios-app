//
//  Picker.swift
//  phpicker
//
//  Created by Takahiro Tominaga on 2022/03/11.
//

import Foundation
import SwiftUI
import PhotosUI
import os

public typealias PHPickerViewCompletionHandler = ( ([PHPickerResult]) -> Void)

public struct SwiftUIPHPicker: UIViewControllerRepresentable {
    // 1
    var configuration: PHPickerConfiguration
    // 2
    var completionHandler: PHPickerViewCompletionHandler?
    
    let logger = Logger(subsystem: "com.smalldesksoftware.SwiftUIPHPicker", category: "SwiftUIPHPicker")
    
    
//    @Binding var player: AVPlayer?
    
    
    public init(configuration: PHPickerConfiguration, completion: PHPickerViewCompletionHandler? = nil) {
        self.configuration = configuration
        self.completionHandler = completion
    }
    
    public func makeCoordinator() -> Coordinator {
        logger.debug("makeCoordinator called")
        return Coordinator(self)
    }
    //(3)
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        logger.debug("makeUIViewController called")
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    //(4)
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        logger.debug("updateUIViewController called")
    }
    
    
    public class Coordinator : PHPickerViewControllerDelegate {
        let parent: SwiftUIPHPicker
        
        init(_ parent: SwiftUIPHPicker) {
            self.parent = parent
        }
        //(5)
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.logger.debug("didFinishPicking called")
            picker.dismiss(animated: true)
//            // (6)
            self.parent.completionHandler?(results)

            guard
                let provider = results.first?.itemProvider,
                let identifier = provider.registeredTypeIdentifiers.first
            else {
                return
            }
        }
    }
}
