import Eureka

protocol DetailViewDelegate: NSObject {
    func removeButtonTapped(title: String?)
    func updateListView()
}

class ToDoDetailViewController: FormViewController {

    private var todoItem: ToDoItem?
    private let todoListViewModel = ToDoViewModel()

    weak var delegate: DetailViewDelegate?

    // MARK: - Initializer

    init(_ todoItem: ToDoItem? = nil) {
        self.todoItem = todoItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup NavigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissDetailVC))
        navigationItem.title = "TO-DO Detail"
        navigationItem.largeTitleDisplayMode = .always

        // Setup TODO detail Form
        setupForm()
    }

    // MARK: - Private Helpers

    private func setupForm() {
        form +++ Section("TODO Details")
        <<< TextRow() {
            $0.tag = "Title"
            $0.title = "Title"
            $0.value = todoItem?.title
        }.onChange { [weak self] row in
            guard let newValue = row.value else { return }
            self?.todoListViewModel.updateToDoTitle(tag: self?.todoItem?.title ?? "", newTitle: newValue)
        }

        <<< TextRow() {
            $0.tag = "Description"
            $0.title = "Description"
            $0.value = todoItem?.descriptions
        }.onChange { [weak self] row in
            guard let newValue = row.value else { return }
            self?.todoListViewModel.updateToDoDescription(tag: self?.todoItem?.descriptions ?? "", newDescription: newValue)
        }

        <<< DateTimeRow() {
            $0.tag = "DueDate"
            $0.title = "Due Date"
            $0.value = todoItem?.dueDate
        }.onChange { [weak self] row in
            guard let newValue = row.value else { return }
            self?.todoListViewModel.updateToDoDueDate(tag: self?.todoItem?.dueDate ?? Date(), newDueDate: newValue)
        }

        <<< CheckRow() {
            $0.tag = todoItem?.title
            $0.title = "Completed"
            $0.value = todoItem?.isCompleted
        }.onChange { [weak self] row in
            guard let newValue = row.value else { return }
            self?.todoListViewModel.updateToDoStatus(tag: row.tag ?? "", isSelected: newValue)
            self?.updateForm()
        }

        +++ Section()
        <<< ButtonRow("Delete") {
            $0.title = "Delete Completed ToDo"
            $0.disabled = Condition.function([], { _ in
                return (self.todoListViewModel.getCompletedTodoCount() == 0)
            })
            $0.onCellSelection { [weak self] _, _ in
                if let title = self?.todoItem?.title {
                    self?.delegate?.removeButtonTapped(title: title)
                }
                self?.deleteRow()
            }
        }
    }

    private func updateForm() {
        if let buttonRow = form.rowBy(tag: "Delete") as? ButtonRow {
            buttonRow.evaluateDisabled()
        }
    }

    private func deleteRow() {
        let ToDoItems = todoListViewModel.getAllToDoItems()
        var completedToDoItems = [ToDoItem]()
        for item in ToDoItems {
            if item.isCompleted {
                completedToDoItems.append(item)
            }
        }

        for item in completedToDoItems {
            if let rowToDelete = form.rowBy(tag: item.title), let section = rowToDelete.section {
                section.remove(at: rowToDelete.indexPath!.row)
                todoListViewModel.deleteToDoItem(item: item)
            }
        }

        updateForm()
    }

    // MARK: - Selector

    @objc
    private func dismissDetailVC() {
        navigationController?.popViewController(animated: true)
        delegate?.updateListView()
    }
}
