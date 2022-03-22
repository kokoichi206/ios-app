//
//  DataManager.swift
//  video-picker
//
//  Created by Takahiro Tominaga on 2022/03/18.
//

import Foundation
import AVFoundation

struct DataManager {
    
//    static func test() {
//        let manager = FileManager.default()
//    }
//
    
    private func makeURL(fileName: String) -> URL? {
        guard let folderURL = URL.createFolder(folderName: "StoredVideos") else {
            print("Can't create url")
            return nil
        }

        let permanentFileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("MOV")
        return permanentFileURL
    }
    
    static func saveURL(fileName: String, url: URL) {

        guard let folderURL = URL.createFolder(folderName: "StoredVideos") else {
            print("Can't create url")
            return
        }

        let permanentFileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("MOV")
        
//        let permanentFileURL = makeURL(fileName: fileName)
        
        print(permanentFileURL)
        
        do{
            let videoData = try Data(contentsOf: url)
            try videoData.write(to: permanentFileURL, options: .atomic)
        } catch {
            return
        }
    }
    
    static func readURLs() -> [AVPlayer] {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("urls: \(paths)")
        return paths.map { url in
            AVPlayer(url: url)
        }
    }
}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
