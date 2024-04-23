import Eureka
import UIKit

protocol CreateToDoViewDelegate: NSObject {
    func saveButtonTapped()
}

class CreateToDoViewController: FormViewController {
    private let todoListViewModel = ToDoViewModel()
    private static let title = "Title"
    private static let description = "Description"
    private static let dueDate = "Due Date"

    weak var delegate: CreateToDoViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCreateToDoVC))
        navigationItem.title = "Create TODO"
        navigationItem.largeTitleDisplayMode = .always

        form +++ Section("Add ToDo")
        <<< TextRow(CreateToDoViewController.title) {
            $0.title = CreateToDoViewController.title
            $0.placeholder = "Add todo"
        }
        <<< TextRow(CreateToDoViewController.description) {
            $0.title = CreateToDoViewController.description
            $0.placeholder = "Add description"
        }
        <<< DateTimeRow(CreateToDoViewController.dueDate) {
            $0.title = CreateToDoViewController.dueDate
            $0.value = Date(timeIntervalSince1970: 0)
        }
        
        +++ Section()
        <<< ButtonRow() {
            $0.title = "Submit"
        }.onCellSelection { [weak self] _, _ in
            self?.saveData()
            self?.delegate?.saveButtonTapped()
        }
    }

    @objc
    func dismissCreateToDoVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateToDoViewController {

    private func saveData() {
        guard let name = (form.rowBy(tag: CreateToDoViewController.title) as? TextRow)?.value,
              let description = (form.rowBy(tag: CreateToDoViewController.description) as? TextRow)?.value,
              let date = (form.rowBy(tag: CreateToDoViewController.dueDate) as? DateTimeRow)?.value else {
            return
        }

        todoListViewModel.addToDoItem(title: name, description: description, dueDate: date, isCompleted: false)

        (form.rowBy(tag: CreateToDoViewController.title) as? TextRow)?.value = nil
        (form.rowBy(tag: CreateToDoViewController.description) as? TextRow)?.value = nil
        (form.rowBy(tag: CreateToDoViewController.dueDate) as? DateTimeRow)?.value = nil

        tableView.reloadData()
    }
}

