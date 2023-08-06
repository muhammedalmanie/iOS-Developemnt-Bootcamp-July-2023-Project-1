import Foundation
import SwiftUI


@MainActor class UserPrefrences: ObservableObject{
    @Published var array: [TaskData] = []
    @AppStorage("taskTitle") var taskTitle: String = ""
    @AppStorage("taskSubtitle") var taskSubtitle: String = ""
//    @AppStorage("taskStatus") var taskStatus: TaskStatus = .InProgress
//    @AppStorage("taskPriority") var taskPriority: TaskPrioritization = .Medium


    func addtoList(title: String, subtitle: String, status: TaskStatus, priority: TaskPrioritization){
        let addToArray = TaskData(title: title, subtitle: subtitle, status: status, priority: priority)
        array.append(addToArray)
    }
}
