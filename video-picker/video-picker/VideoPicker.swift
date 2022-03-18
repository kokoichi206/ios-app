//
//  VideoPicker.swift
//  video-picker
//
//  Created by Takahiro Tominaga on 2022/03/18.
//

import Foundation

import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var player: AVPlayer?
    @Binding var showingAlert: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            
            // picking has finished, so set isPresented to false
            parent.isPresented = false
            
            guard
                let provider = results.first?.itemProvider,
                let identifier = provider.registeredTypeIdentifiers.first
            else {
                return
            }
            
            provider.loadFileRepresentation(forTypeIdentifier: identifier) { [weak self] (url, error) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                
                provider.loadItem(forTypeIdentifier: identifier, options: nil) { [weak self] (url, error) in
                    if let error = error {
                        print("error: \(error)")
                        return
                    }
                    
                    if let url = url as? URL {
                        self?.parent.player = AVPlayer(url: url)
                    }
                }
            }
        }
    }
}
