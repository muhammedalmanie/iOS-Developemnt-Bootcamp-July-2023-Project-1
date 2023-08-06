//
//  TaskPrioritization.swift
//  TaskManager
//
//  Created by Muhammed on 8/6/23.
//

import Foundation
import SwiftUI

enum TaskPrioritization: CaseIterable {
    case Low
    case Medium
    case High

    static var allCases: [TaskPrioritization] {
        return [.Low, .Medium, .High]
    }
}
