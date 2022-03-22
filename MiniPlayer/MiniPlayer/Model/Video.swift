//
//  Video.swift
//  MiniPlayer
//
//  Created by Takahiro Tominaga on 2022/03/22.
//

import SwiftUI

struct Video: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var title: String
}

var videos = [

    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
]
