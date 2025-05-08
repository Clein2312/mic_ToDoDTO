import Fluent

struct CreateTodo: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("isDone", .bool, .required)
            .field("timestamp", .datetime, .required)
            .field("deadline", .datetime)
            .field("priority", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("todos").delete()
    }
}
