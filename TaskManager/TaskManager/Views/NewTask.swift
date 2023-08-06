//
//  NewTask.swift
//  TaskManager
//
//  Created by Muhammed on 8/5/23.
//

import Foundation
import SwiftUI
import UIKit

struct NewTask: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: TasksViewModel
    @State private var taskTitle: String = ""
    @State private var taskSubtitle: String = ""
    @State private var taskStatus: TaskStatus = .Todo
    @State private var taskPriority: TaskPrioritization = .Medium
    let statusOptions = TaskStatus.allCases
    let priorityOptions = TaskPrioritization.allCases
    let filterTasks: (String) -> Void
    @Binding var searchedText: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $taskTitle)
                    TextField("Subtitle", text: $taskSubtitle)
                }
                
                Section {
                    Picker("Status", selection: $taskStatus) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(statusToString(status)).tag(status)
                        }
                    }
                }
                
                Section {
                    Picker("Priority", selection: $taskPriority) {
                        ForEach(priorityOptions, id: \.self) { priority in
                            Text(priorityToString(priority)).tag(priority)
                        }
                    }
                }
            }
            .navigationBarTitle("New Task", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                        searchedText = ""
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        let newTask = TaskData(
            title: taskTitle,
            subtitle: taskSubtitle,
            status: taskStatus,
            priority: taskPriority
        )
        viewModel.addTask(newTask)
        filterTasks(searchedText)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func statusToString(_ status: TaskStatus) -> String {
        switch status {
        case .Backlog: return "Backlog"
        case .Todo: return "Todo"
        case .InProgress: return "In Progress"
        case .Done: return "Done"
        }
    }
    
    private func priorityToString(_ priority: TaskPrioritization) -> String {
        switch priority {
        case .Low: return "Low"
        case .Medium: return "Medium"
        case .High: return "High"
        }
    }
}
