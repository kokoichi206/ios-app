//
//  TodoListApp.swift
//  TodoList
//
//  Created by Takahiro Tominaga on 2022/03/08.
//

import SwiftUI

@main
struct TodoListApp: App {

    @StateObject var listViewModel: ListViewModel = ListViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
