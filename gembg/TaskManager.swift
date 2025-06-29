
import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var executionTime: Date
    var executed: Bool = false
}

class TaskManager {
    static let shared = TaskManager()
    private let tasksKey = "tasks"
    
    private init() {}

    func scheduleTask(task: Task) {
        var tasks = getTasks()
        tasks.append(task)
        saveTasks(tasks)
    }

    func executePendingTasks() {
        var tasks = getTasks()
        let now = Date()
        let pendingTasks = tasks.filter { $0.executionTime == now }
        var modifiedTasks: [Task] = []
        var otherTasks =  tasks.filter { $0.executionTime != now }

        for task in pendingTasks {
            NotificationManager.shared.sendNotification(title: "Task Executed", body: "Task '\(task.name)' was executed.")
            modifiedTasks.append(task)
        }

        tasks.removeAll { $0.executionTime <= now }
        let combined = Array([modifiedTasks, otherTasks].joined())
        saveTasks(combined)
    }

    func getTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: tasksKey) {
            if let tasks = try? JSONDecoder().decode([Task].self, from: data) {
                return tasks
            }
        }
        return []
    }

    private func saveTasks(_ tasks: [Task]) {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
}
