//
//  Location.swift
//  SwiftfulMappApp
//
//  Created by Takahiro Tominaga on 2022/04/09.
//

import Foundation
import MapKit

struct Location: Identifiable {
    
//    let id = UUID().uuidString
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    // Identifiable
    var id: String {
        name + cityName
    }
}
