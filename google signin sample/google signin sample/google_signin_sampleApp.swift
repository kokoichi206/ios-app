//
//  google_signin_sampleApp.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/28.
//

import SwiftUI
import Firebase

@main
struct google_signin_sampleApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

      print("Configured Firebase!!!")

    return true
  }
}
