import Eureka
import UIKit

class ToDoListViewController: FormViewController {

    private let todoListViewModel = ToDoViewModel()
    private let section = Section("Todo List Section")

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup NavigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.title = "TO-DO List"
        navigationItem.largeTitleDisplayMode = .always

        // Setup TableView
        setupTableView()
    }

    // MARK: - Private Helper

    private func setupTableView() {
        let todoItems = todoListViewModel.getAllToDoItems()

        for item in todoItems {
            section <<< createLabelRow(item: item)
        }

        form +++ section
    }

    private func createLabelRow(item: ToDoItem) -> LabelRow {
        let labelRow = LabelRow() {
            $0.title = item.title
            $0.value = item.descriptions
        }.onCellSelection { _, row in
            self.presentToDoDetailVC(row.title)
        }
        return labelRow
    }

    private func presentToDoDetailVC(_ rowTitle: String?) {
        guard let rowTitle else {
            print("Not able to find todo item!!")
            return
        }

        var todoItem: ToDoItem?
        for item in todoListViewModel.getAllToDoItems() {
            if item.title == rowTitle {
                todoItem = item
            }
        }

        if let todoItem {
            let todoDetailVC = ToDoDetailViewController(todoItem)
            todoDetailVC.delegate = self
            todoDetailVC.modalTransitionStyle = .coverVertical
            todoDetailVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(todoDetailVC, animated: true)
        }
    }

    // MARK: - Selector

    @objc
    private func addButtonTapped() {
        let createToDoVC = CreateToDoViewController()
        createToDoVC.delegate = self
        createToDoVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(createToDoVC, animated: true)
    }
}

extension ToDoListViewController: CreateToDoViewDelegate {
    func saveButtonTapped() {
        if let todoItem = todoListViewModel.getAllToDoItems().last {
            let labelRow = createLabelRow(item: todoItem)
            section.append(labelRow)
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController: DetailViewDelegate {
    func updateListView() {
        tableView.reloadData()
    }

    func removeButtonTapped(title: String?) {
        for row in section {
            if let title, let textRow = row as? TextRow, textRow.title == title {
                section.remove(at: row.indexPath!.row)
                break
            }
        }
        tableView.reloadData()
    }
}
