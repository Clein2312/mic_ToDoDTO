//
//  ToDoItemRow.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 05.05.25.
//

import SwiftUI

struct ToDoItemRow: View {
    let item: ToDoItem
    var body: some View {
        VStack {
            
            
            HStack {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isDone ? .green : .gray)
                
                
                
                Text(item.title)
                    .strikethrough(item.isDone)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(item.isDone ? .gray : .primary)
                
                priorityView(for: item.priority)
                
                if let deadline = item.deadline {
                    Text("due:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(deadline, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                
                
            }.padding(.horizontal, 20)
        }
    }
}

private func priorityView(for priority: ToDoItem.Priority) -> some View {
    HStack(spacing: 4) {
                switch priority {
                case .high:
                    Image(systemName: "exclamationmark")
                        .foregroundColor(.red)
                        .font(.caption)
                    Text("High")
                        .font(.caption)
                        .foregroundColor(.red)
                case .medium:
                    Image(systemName: "arrow.right")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("Medium")
                        .font(.caption)
                        .foregroundColor(.orange)
                case .low:
                    Image(systemName: "arrow.down")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("Low")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }


#Preview {
    ToDoItemRow(item: ToDoItem(timestamp: .now, id: UUID(), title: "Test", isDone:false, deadline: .now, priority:   .low))
}
