//
//  TasksViewModel.swift
//  TaskManager
//
//  Created by Muhammed on 8/5/23.
//

import Foundation

class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskData] = makeTaskData()
    var filterTasks: ((String) -> Void)?
    var searchedText: String = ""

    func addTask(_ task: TaskData) {
        tasks.append(task)
        objectWillChange.send()
        filterTasks?(searchedText)

    }

    func deleteTask(_ task: TaskData) {
        tasks.removeAll { $0.id == task.id }
    }

    func updateTask(_ updatedTask: TaskData) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
}
