//
//  Item.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 30.04.25.
//

import Foundation
import SwiftData

@Model
final class ToDoItem {
    var timestamp: Date
    @Attribute(.unique) var id: UUID
    var title: String
    var isDone: Bool
    var priority: Priority
    var deadline: Date?
    
    enum Priority: String, CaseIterable, Codable, Identifiable{
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var id: Self {self}
        
    }
    
    init(timestamp: Date = .now, id: UUID = UUID(), title: String, isDone: Bool = false, deadline: Date? = nil, priority: Priority = .medium) {
        self.timestamp = timestamp
        self.id = id
        self.title = title
        self.isDone = isDone
        self.deadline = deadline ?? nil
        self.priority = priority
    }
}

struct ToDoItemCreateDTO: Codable {
    var title: String
    var timestamp: Date = Date()
    var isDone: Bool = false
    var deadline: Date?
    var priority: String = "Medium"
    
}

struct ToDoItemUpdateDTO: Codable {
    var title: String?
    var isDone: Bool?
    var deadline: Date?
    var priority: String?
}

struct ToDoItemResponseDTO: Codable {
    var timestamp: Date?
    var id: UUID?
    var title: String?
    var isDone: Bool?
    var deadline: Date?
    var priority: String?
}




