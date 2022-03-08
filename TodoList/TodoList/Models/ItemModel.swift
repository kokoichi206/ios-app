//
//  ItemModel.swift
//  TodoList
//
//  Created by Takahiro Tominaga on 2022/03/09.
//

import Foundation

struct ItemModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let isCompleted: Bool
}
