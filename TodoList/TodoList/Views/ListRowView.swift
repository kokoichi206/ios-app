//
//  ListRowView.swift
//  TodoList
//
//  Created by Takahiro Tominaga on 2022/03/08.
//

import SwiftUI

struct ListRowView: View {

    let item : ItemModel

    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle": "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}
