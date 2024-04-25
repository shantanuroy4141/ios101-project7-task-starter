//
//  TaskListViewController.swift
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTasks()
    }

    @IBAction func didTapNewTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskVC = segue.destination as? TaskComposeViewController {
            taskVC.taskToEdit = sender as? Task
            taskVC.onComposeTask = { [weak self] task in
                self?.handleTaskUpdate(task)
            }
        }
    }

    private func refreshTasks() {
        tasks = Task.getTasks()
        sortTasks()
        updateEmptyState()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    private func sortTasks() {
        tasks.sort {
            if $0.isComplete && $1.isComplete {
                return $0.completedDate! < $1.completedDate!
            } else if !$0.isComplete && !$1.isComplete {
                return $0.createdDate < $1.createdDate
            } else {
                return !$0.isComplete && $1.isComplete
            }
        }
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = !tasks.isEmpty
    }

    private func handleTaskUpdate(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        Task.save(tasks)
        refreshTasks()
    }

    func presentUserFeedback(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true)
            }
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task, onCompleteButtonTapped: { [weak self] task in
            task.save()
            self?.presentUserFeedback(message: "Task Updated")
            self?.refreshTasks()
        })
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            Task.save(tasks)
            presentUserFeedback(message: "Task Deleted")
            refreshTasks()
        }
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "ComposeSegue", sender: selectedTask)
    }
}
