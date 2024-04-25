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
    private(set) var completedDate: Date?
    let createdDate: Date
    let id: String

    // Custom initializer to set default values
    init(title: String, note: String? = nil, dueDate: Date = Date(), createdDate: Date = Date(), id: String = UUID().uuidString) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
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
