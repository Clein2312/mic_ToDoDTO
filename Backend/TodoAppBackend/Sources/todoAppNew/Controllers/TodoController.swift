import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("todos")

        todos.get(use: self.index)
        todos.post(use: self.create)
        todos.group(":id") { todo in
            todo.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [TodoDTO] {
        try await Todo.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> TodoDTO {
        let todo = try req.content.decode(TodoDTO.self).toModel()

        try await todo.save(on: req.db)
        return todo.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        print(req.parameters)
        guard let todo = try await Todo.find(req.parameters.get("id"), on: req.db)
            
        else {
            print("EEEEEEEE")
            throw Abort(.notFound)
        }

        try await todo.delete(on: req.db)
        return .noContent
    }
}
