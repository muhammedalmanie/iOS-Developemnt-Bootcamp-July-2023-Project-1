//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Muhammed on 8/5/23.
//

import Foundation
import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewModel: TasksViewModel
    @State private var showDeleteConfirmationAlert = false
    @State private var isEditMode = false
    @State private var editedTitle = ""
    @State private var editedSubtitle = ""
    @State private var editedStatus = TaskStatus.Todo
    @State private var editedPriority = TaskPrioritization.Medium
    @Environment(\.presentationMode) var presentationMode
    var task: TaskData

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                if isEditMode {
                    TextField("Title", text: $editedTitle)
                } else {
                    Text(task.title)
                }
            }

            Section(header: Text("Subtitle")) {
                if isEditMode {
                    TextField("Subtitle", text: $editedSubtitle)
                } else {
                    Text(task.subtitle)
                }
            }

            Section(header: Text("Status")) {
                if isEditMode {
                    Picker("Status", selection: $editedStatus) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(statusToString(status)).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } else {
                    Text(statusToString(task.status))
                }
            }

            Section(header: Text("Priority")) {
                if isEditMode {
                    Picker("Priority", selection: $editedPriority) {
                        ForEach(TaskPrioritization.allCases, id: \.self) { priority in
                            Text(priorityToString(priority)).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } else {
                    Text(priorityToString(task.priority))
                }
            }
        }
        .navigationBarTitle("Task Detail", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditMode {
                    Button("Done") {
                        updateTask()
                        isEditMode = false
                    }
                } else {
                    HStack {
                        Button("Edit") {
                            isEditMode = true
                            editedTitle = task.title
                            editedSubtitle = task.subtitle
                            editedStatus = task.status
                            editedPriority = task.priority
                        }

                        Button("Delete") {
                            showDeleteConfirmationAlert = true
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $showDeleteConfirmationAlert) {
                            Alert(
                                title: Text("Delete Task"),
                                message: Text("Are you sure you want to delete this task?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteTask()
                                    presentationMode.wrappedValue.dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func deleteTask() {
        viewModel.deleteTask(task)
    }

    private func updateTask() {
        let updatedTask = TaskData(
            id: task.id,
            title: editedTitle,
            subtitle: editedSubtitle,
            status: editedStatus,
            priority: editedPriority
        )
        viewModel.updateTask(updatedTask)
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

