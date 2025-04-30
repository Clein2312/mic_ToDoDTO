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
    var id: UUID
    var title: String
    var isDone: Bool = false
    var deadline: Date?
    
    init(timestamp: Date, id: UUID = UUID(), title: String, isDone: Bool = false, deadline: Date? = nil) {
        self.timestamp = timestamp
        self.id = UUID()
        self.title = title
        self.isDone = isDone
        self.deadline = deadline ?? nil
    }
}

struct ToDoItemCreateDTO: Codable {
    var title: String
    var isDone: Bool = false
    var deadline: Date?
    
}

struct ToDoItemUpdateDTO: Codable {
    var title: String?
    var isDone: Bool?
    var deadline: Date?
}






