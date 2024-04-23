import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title = "Default Title"
    @objc dynamic var descriptions = "Default Description"
    @objc dynamic var dueDate = Date()
    @objc dynamic var isCompleted = false
}
