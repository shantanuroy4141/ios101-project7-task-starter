//
//  TaskComposeViewController.swift
//

import UIKit

class TaskComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    // Optional task to edit; determines if in "Edit Task" or "New Task" mode.
    var taskToEdit: Task?

    // Closure called when a task is created or edited.
    var onComposeTask: ((Task) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        if let task = taskToEdit {
            titleField.text = task.title
            noteField.text = task.note
            datePicker.date = task.dueDate
            self.title = "Edit Task"
        } else {
            self.title = "New Task"
        }
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let title = titleField.text, !title.isEmpty else {
            presentAlert(title: "Missing Title", message: "Please enter a title for the task.")
            return
        }

        // If editing an existing task, update its properties
        if var task = taskToEdit {
            task.title = title
            task.note = noteField.text
            task.dueDate = datePicker.date
            // Call the closure with the updated task
            onComposeTask?(task)
        } else {
            // If creating a new task, initialize a new instance
            let newTask = Task(title: title, note: noteField.text, dueDate: datePicker.date)
            // Call the closure with the new task
            onComposeTask?(newTask)
        }
        
        dismiss(animated: true)
    }




    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
