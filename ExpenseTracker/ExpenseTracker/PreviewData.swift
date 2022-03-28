//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Takahiro Tominaga on 2022/03/28.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 1, date: "01/22/2022", institution: "Desjardins", account: "xxx", merchant: "Apple", amount: 11.22, type: "credit", categoryId: 777, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
