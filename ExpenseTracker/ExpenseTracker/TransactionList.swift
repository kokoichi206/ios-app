//
//  TransactionList.swift
//  ExpenseTracker
//
//  Created by Takahiro Tominaga on 2022/03/29.
//

import SwiftUI

struct TransactionList: View {
    
    @EnvironmentObject var transactionListViewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            List {
                // MARK: Transaction Groups
                ForEach(Array(transactionListViewModel.groupTransactionsByMonth()), id:\.key) { month, transactions in
                    Section {
                        // MARK: Transaction List
                        ForEach(transactions) {transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        // MARK: Transaction Month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListViewModel: TransactionListViewModel = {
        let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        return transactionListViewModel
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                TransactionList()
            }
            NavigationView {
                TransactionList()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(transactionListViewModel)
    }
}
