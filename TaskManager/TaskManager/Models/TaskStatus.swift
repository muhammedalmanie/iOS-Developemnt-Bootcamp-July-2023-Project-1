//
//  TaskStatus.swift
//  TaskManager
//
//  Created by Muhammed on 8/6/23.
//

import Foundation
import SwiftUI

enum TaskStatus: CaseIterable {
    case Backlog
    case Todo
    case InProgress
    case Done

    static var allCases: [TaskStatus] {
        return [.Backlog, .Todo, .InProgress, .Done]
    }
}
