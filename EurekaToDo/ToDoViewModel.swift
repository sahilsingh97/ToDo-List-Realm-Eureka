import Foundation
import RealmSwift

class ToDoViewModel {
    private var realm: Realm

    init() {
        realm = try! Realm()
    }

    func getAllToDoItems() -> Results<ToDoItem> {
        return realm.objects(ToDoItem.self)
    }

    func getCompletedTodoCount() -> Int {
        var resultList = [ToDoItem]()
        for item in getAllToDoItems() {
            if item.isCompleted {
                resultList.append(item)
            }
        }
        return resultList.count
    }

    func addToDoItem(title: String, description: String, dueDate: Date, isCompleted: Bool) {
        let todoItem = ToDoItem()
        todoItem.title = title
        todoItem.descriptions = description
        todoItem.isCompleted = isCompleted

        try! realm.write {
            realm.add(todoItem)
        }
    }

    func deleteToDoItem(item: ToDoItem) {
        try! realm.write {
            realm.delete(item)
        }
    }

    // Update TODO form elements
    func updateToDoStatus(tag: String, isSelected: Bool) {
        let items = realm.objects(ToDoItem.self).filter("title == %@", tag)
        try! realm.write {
            if let item = items.first {
                item.isCompleted = isSelected ? true : false
            }
        }
    }

    func updateToDoTitle(tag: String, newTitle: String) {
        let items = realm.objects(ToDoItem.self).filter("title == %@", tag)
        try! realm.write {
            if let item = items.first {
                item.title = newTitle
            }
        }
    }

    func updateToDoDescription(tag: String, newDescription: String) {
        let items = realm.objects(ToDoItem.self).filter("descriptions == %@", tag)
        try! realm.write {
            if let item = items.first {
                item.descriptions = newDescription
            }
        }
    }

    func updateToDoDueDate(tag: Date, newDueDate: Date) {
        let items = realm.objects(ToDoItem.self).filter("title == %@", tag)
        try! realm.write {
            if let item = items.first {
                item.dueDate = newDueDate
            }
        }
    }
}
