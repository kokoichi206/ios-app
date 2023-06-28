//
//  RootViwe.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/29.
//

import SwiftUI

struct RootView: View {

    @State private var showSignInView: Bool = false

    var body: some View {

        ZStack {
            NavigationStack {
                SettingsView(showSigInView: $showSignInView)
            }
        }
        .onAppear {
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

struct RootViwe_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
