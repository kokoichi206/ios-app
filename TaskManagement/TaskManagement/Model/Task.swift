//
//  Task.swift
//  TaskManagement
//
//  Created by Takahiro Tominaga on 2022/01/21.
//

import SwiftUI

// Task Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
