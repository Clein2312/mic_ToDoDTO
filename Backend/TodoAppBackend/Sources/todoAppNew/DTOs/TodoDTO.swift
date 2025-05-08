import Fluent
import Vapor

struct TodoDTO: Content {
    var id: UUID?
    var title: String?
    var isDone: Bool?
    var timestamp: Date?
    var deadline: Date?
    var priority: String?
    
    func toModel() -> Todo {
        let model = Todo()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        if let isDone = self.isDone {
            model.isDone = isDone
        }
        if let timestamp = self.timestamp {
            model.timestamp = timestamp
        }
        if let deadline = self.deadline {
            model.deadline = deadline
        }
        if let priority = self.priority {
            model.priority = priority
        }
        return model
    }
}
