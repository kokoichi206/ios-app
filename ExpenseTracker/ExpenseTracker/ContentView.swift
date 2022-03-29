//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Takahiro Tominaga on 2022/03/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)  // change back button color
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let transactionListViewModel: TransactionListViewModel = {
        let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        return transactionListViewModel
    }()
    
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListViewModel)
    }
}
