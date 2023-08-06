// ContentView.swift
// MySwiftUIApp
//
// Created by Muhammed on 7/30/23.

import SwiftUI
import UIKit

struct ContentView: View {
    let statuses: [String] = ["All", "Backlog", "Todo", "In-Progress", "Done"]
    @StateObject private var viewModel = TasksViewModel()
    @State private var isPresentingNewTaskSheet = false
    @State private var searchedText = ""
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchedText)
                        .font(Font.system(size: 23))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(18)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(statuses, id: \.self) { status in
                            Button {
                                filteredTasks = filterTasksByStatus(status)
                            } label: {
                                Text(status)
                                    .padding(10)
                                    .foregroundColor(isDarkMode ? .white : .primary)
                                    .background(Color.clear)
                                    .cornerRadius(25)
                                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.secondary, lineWidth: 0.95))
                            }
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 20))
                }
                
                ScrollView {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailView(viewModel: viewModel, task: task)) {
                            VStack {
                                HStack {
                                    Circle()
                                        .foregroundColor(getColorForPriority(task.priority))
                                        .frame(width: 20, height: 20)
                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .font(.headline)
                                        Text(task.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    Text(statusText(for: task.status))
                                         .font(.subheadline)
                                         .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 20)
                            .background(
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.secondary, lineWidth: 0.95))
                            )
                        }
                    }
                }
                
                Button("Add New Task") {
                    isPresentingNewTaskSheet = true
                }
                .padding()
                .foregroundColor(isDarkMode ? .white : .primary)
                .background(Color.clear)
                .cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.secondary, lineWidth: 0.95))
            }
            .padding()
            .navigationBarItems(trailing: Button(action: {
                toggleDarkMode()
            }) {
                Image(systemName: isDarkMode ? "moon.fill" : "moon")
                    .foregroundColor(isDarkMode ? .white : .primary)
                    .font(.title)
            })
            .background(isDarkMode ? Color.black : Color.brown.opacity(0.2))
            .foregroundColor(isDarkMode ? .white : .black)
            
            .onAppear {
                prepareDataForUser()
            }
            .onChange(of: searchedText) { newValue in
                filterTasksBasedOn(newValue)
            }
            .navigationBarTitle("DOne")
        }
        .sheet(isPresented: $isPresentingNewTaskSheet) {
            NewTask(viewModel: viewModel, filterTasks: filterTasksBasedOn, searchedText: $searchedText)
            
        }
        .foregroundColor(.primary)
    }
    
    @State private var filteredTasks: [TaskData] = []
    func prepareDataForUser() {
        filteredTasks = viewModel.tasks
    }
    
    private func toggleDarkMode() {
         isDarkMode.toggle()
     }
    
    private func filterTasksBasedOn(_ value: String) {
        if value.isEmpty {
            filteredTasks = viewModel.tasks
        } else {
            let lowercasedValue = value.lowercased()
            filteredTasks = viewModel.tasks.filter { task in
                return task.title.lowercased().contains(lowercasedValue)
            }
        }
    }
    
    private func filterTasksByStatus(_ status: String) -> [TaskData] {
        switch status {
        case "All":
            return viewModel.tasks
        case "Backlog":
            return viewModel.tasks.filter { $0.status == .Backlog }
        case "Todo":
            return viewModel.tasks.filter { $0.status == .Todo }
        case "In-Progress":
            return viewModel.tasks.filter { $0.status == .InProgress }
        case "Done":
            return viewModel.tasks.filter { $0.status == .Done }
        default:
            return viewModel.tasks
        }
    }

    func getColorForPriority(_ priority: TaskPrioritization) -> Color {
        switch priority {
        case .Low:
            return Color.green
        case .Medium:
            return Color.orange
        case .High:
            return Color.red
        default:
            return Color.green
        }
    }

    func statusText(for status: TaskStatus) -> String {
        switch status {
        case .Backlog:
            return "Backlog"
        case .Todo:
            return "Todo"
        case .InProgress:
            return "In-Progress"
        case .Done:
            return "Done"
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
