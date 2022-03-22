//
//  FilesManager.swift
//  video-picker
//
//  Created by Takahiro Tominaga on 2022/03/19.
//

import Foundation

class FilesManager {
    
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    
    private let testFileName = "movies"
//    static let file
    
    
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
   
    func makeURL(forFileNamed fileName: String) -> URL? {
//        let fileManager: FileManager = .default
        

        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
//        return url
        return url.appendingPathComponent(testFileName).appendingPathExtension("MOV")
    }
    
    func save(fileNamed: String, data: Data) throws {
//        let fileManager: FileManager = .default
        
        
        guard let url = makeURL(forFileNamed: fileNamed) else {
            print("error: makeURL")
            throw Error.invalidDirectory
        }
        print("NO error: makeURL completed")
        if fileManager.fileExists(atPath: url.absoluteString) {
            print("error: fileExists")
            throw Error.fileAlreadyExists
        }
        print("NO error: file not Exists")
        do {
            print("url: FilesManager#save \(url)")
            print("url: data \(data)")
            try data.write(to: url)
        } catch {
//            debugPrint(error)
            print("error: while saving")
            print("error: \(error.localizedDescription)")
            throw Error.writtingFailed
        }
    }
    
     func read(fileNamed: String) throws -> URL { // Data
//        let fileManager: FileManager = .default
        
        
        guard let url = makeURL(forFileNamed: fileNamed) else {
            print("error: invalidDirectory")
            throw Error.invalidDirectory
        }
        print("url: FilesManager#read \(url)")
        guard fileManager.fileExists(atPath: url.absoluteString) else {
            print("error: fileNotExists")
            throw Error.fileNotExists
        }
        return url
//       do {
//           return try Data(contentsOf: url)
//       } catch {
//           debugPrint(error)
//           throw Error.readingFailed
//       }
   }
}
