//
//  LocationsViewModel.swift
//  SwiftfulMappApp
//
//  Created by Takahiro Tominaga on 2022/04/09.
//

import Foundation

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location]
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
    }
}
