//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {
    var title: String
    var note: String?
    var dueDate: Date
    var isComplete: Bool = false
    var completedDate: Date?
    let createdDate: Date
    let id: String

    // Default initializer for new tasks
    init(title: String, note: String? = nil, dueDate: Date = Date(), isComplete: Bool = false) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.isComplete = isComplete
        self.completedDate = nil
        self.createdDate = Date()
        self.id = UUID().uuidString
    }
    
    // Initializer for updating existing tasks with a specified completedDate and id
    init(title: String, note: String?, dueDate: Date, isComplete: Bool, completedDate: Date?, createdDate: Date, id: String) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.isComplete = isComplete
        self.completedDate = completedDate
        self.createdDate = createdDate
        self.id = id
    }
}



// MARK: - Task + UserDefaults
extension Task {


    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }


    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        if let tasksData = UserDefaults.standard.data(forKey: "tasks") {
            let decoder = JSONDecoder()
            if let loadedTasks = try? decoder.decode([Task].self, from: tasksData) {
                return loadedTasks
            }
        }
        return []
    }


    // Add a new task or update an existing task with the current task.
    func save() {
        var tasks = Task.getTasks()
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self // Updates the existing task
        } else {
            tasks.append(self) // Adds a new task
        }
        Task.save(tasks)
    }

}
