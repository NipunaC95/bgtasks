
import SwiftUI

struct ContentView: View {
    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()
    @State private var tasks: [Task] = []

    var body: some View {
        NavigationView {
            VStack {
                TextField("Task Name", text: $taskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                DatePicker("Task Time", selection: $taskDate, in: Date()...)
                    .padding()

                Button(action: {
                    let newTask = Task(name: taskName, executionTime: taskDate)
                    TaskManager.shared.scheduleTask(task: newTask)
                    taskName = ""
                    loadTasks()
                }) {
                    Text("Schedule Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
                List(tasks) { task in
                    VStack(alignment: .leading) {
                        Text(task.name).font(.headline)
                        Text("Execute at: \(task.executionTime, formatter: itemFormatter)").font(.subheadline)
                    }
                }
                .onAppear(perform: loadTasks)
                
                List(tasks.filter { $0.executed }) { task in
                    VStack(alignment: .leading) {
                        Text(task.name).font(.headline)
                        Text("Execute at: \(task.executionTime, formatter: itemFormatter)").font(.subheadline)
                    }
                }
                .onAppear(perform: loadTasks)
            }
            .navigationTitle("Task Scheduler")
        }
    }

    private func loadTasks() {
        tasks = TaskManager.shared.getTasks()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
