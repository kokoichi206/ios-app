//
//  SettingsView.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/29.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {

    func logout() throws {
        try AuthenticationManager.shared.signout()
    }
}

struct SettingsView: View {

    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSigInView: Bool

    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logout()
                        showSigInView = true
                    } catch {
                        print("Error \(error)")
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSigInView: .constant(false))
        }
    }
}
