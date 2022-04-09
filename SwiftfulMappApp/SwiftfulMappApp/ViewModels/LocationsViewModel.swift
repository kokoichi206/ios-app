//
//  LocationsViewModel.swift
//  SwiftfulMappApp
//
//  Created by Takahiro Tominaga on 2022/04/09.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    // All loaded locations
    @Published var locations: [Location]
    
    @Published var mapLocation: Location {
        // Every time this value is sed, this func is automatically called
        didSet {
            updateMapRegion(locaiton: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!

        self.updateMapRegion(locaiton: locations.first!)
    }
    
    private func updateMapRegion(locaiton: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: locaiton.coordinates,
                span: mapSpan)
        }
    }
}
