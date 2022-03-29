//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Takahiro Tominaga on 2022/03/28.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
    @StateObject var transactionListViewModel = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListViewModel)
        }
    }
}
