//
//  ItemViewModel.swift
//  ToDo_Vapor
//
//  Created by Patrick on 30.04.25.
//

import SwiftUI
import SwiftData


@MainActor
final class ToDoItemViewModel: ObservableObject {
    var modelContext: ModelContext?
    
    func onAppear(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await fetchToDoItems()
        }
    }
    
    // MARK: - Create an item
    func createToDoItem(data: ToDoItemCreateDTO) async {
        guard let context = modelContext else { return }
        do {
            let createdData = try await APIService.shared.createToDoItem(data: data)
            let todoItem = ToDoItem(
                id: createdData.id,
                title: createdData.title,
            )
            context.insert(todoItem)
            try context.save()
        } catch {
            print("Error creating community: \(error)")
        }
    }
    
    func fetchToDoItem(id: UUID) async {
        guard let context = modelContext else { return }
        do {
            let dto = try await APIService.shared.fetchToDoItem(id: id)
            let todoItem = ToDoItem(
                id: dto.id,
                title: dto.title,
            )
            context.insert(todoItem)
            try context.save()
        } catch {
            print("Error fetching community: \(error)")
        }
    }
    
    func fetchToDoItems() async {
        guard let context = modelContext else { return }
        do {
            let remoteToDoItems = try await APIService.shared.fetchToDoItems() // [CommunityResponseDTO]
            for data in remoteToDoItems {
                let todoItem = ToDoItem(
                    id: data.id,
                    title: data.title
                )
                context.insert(todoItem)
            }
            try context.save()
        } catch {
            print("Error fetching communities: \(error)")
        }
    }
    
    func updateToDoItem(toDoItem: ToDoItem, data: ToDoItemUpdateDTO) async {
        guard let context = modelContext else { return }
        do {
            let updatedData = try await APIService.shared.updateToDoItem(id: toDoItem.id, data: data)
            toDoItem.title = updatedData.title
            try context.save()
        } catch {
            print("Error updating community: \(error)")
        }
    }
    
    // MARK: - Delete an item
    func deleteToDoItem(toDoItem: ToDoItem) async {
        guard let context = modelContext else { return }
        do {
            try await APIService.shared.deleteToDoItem(id: toDoItem.id)
            context.delete(toDoItem)
            try context.save()
        } catch {
            print("Error deleting community: \(error)")
        }
    }
}
