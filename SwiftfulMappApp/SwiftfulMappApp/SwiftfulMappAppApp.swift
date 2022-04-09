//
//  SwiftfulMappAppApp.swift
//  SwiftfulMappApp
//
//  Created by Takahiro Tominaga on 2022/04/09.
//

import SwiftUI

@main
struct SwiftfulMappAppApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
