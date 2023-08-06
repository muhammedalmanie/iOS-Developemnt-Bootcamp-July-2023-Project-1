//
//  TaskData.swift
//  TaskManager
//
//  Created by Muhammed on 8/6/23.
//

import Foundation
import SwiftUI

struct TaskData: Identifiable {
    var id: UUID = UUID()
    let title: String
    let subtitle: String
    let status: TaskStatus
    let priority: TaskPrioritization
}

func makeTaskData() -> [TaskData] {
    return []
}
