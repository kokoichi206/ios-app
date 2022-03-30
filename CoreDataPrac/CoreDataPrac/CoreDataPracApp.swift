//
//  CoreDataPracApp.swift
//  CoreDataPrac
//
//  Created by Takahiro Tominaga on 2022/03/30.
//

import SwiftUI

@main
struct CoreDataPracApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(coreDM: CoreDataManager())
        }
    }
}
