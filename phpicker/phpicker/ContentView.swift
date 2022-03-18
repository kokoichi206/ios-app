//
//  ContentView.swift
//  phpicker
//
//  Created by Takahiro Tominaga on 2022/03/10.
//

import SwiftUI
import PhotosUI
import os
//import SwiftUIPHPicker

struct ContentView: View {
    // (1)
    @State private var images:[UIImage] = []
//    @State private var images:[Video] = []
    weak var videoView: UIView!
    // (2)
    @State private var showPHPicker:Bool = false
    // (3)
    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
//        config.filter = .videos
        config.preferredAssetRepresentationMode = .current
        return config
    }
    let logger = Logger(subsystem: "com.smalldesksoftware.PHPickerSample", category: "PHPickerSample")

    var columns: [GridItem] = Array(repeating: .init(.fixed(100)), count: 3)
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPHPicker.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                })
            }
            .padding()
            Spacer()
            LazyVGrid(columns: columns) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable().scaledToFit()
                }
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $showPHPicker) {
            // (4)
            SwiftUIPHPicker(configuration: ContentView.config) { results in
                for result in results {
                    let itemProvider = result.itemProvider
                    print(type(of: itemProvider))
                    if itemProvider.canLoadObject(ofClass: UIImage.self) {
                        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            if let image = image as? UIImage {
                                DispatchQueue.main.async {
                                    // (5)
                                    self.images.append(image)
                                }
                            }
                            if let error = error {
                                logger.error("\(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
}
