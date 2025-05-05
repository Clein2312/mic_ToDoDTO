//
//  ContentView.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 30.04.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ToDoItem]
    @State private var newItemTitle: String = ""
    
    var body: some View {
            
            
            
            NavigationSplitView {
                VStack{
                    Text("ToDo App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.tint)
                        
                    TextField("New ToDO item...", text: $newItemTitle)
                        .onSubmit {
                            addItem()
                        }
                        .padding()
                        .cornerRadius(8)
                        .font(.headline)
                    
                    Divider()
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                printItemInfo(item: item)
                            } label: {
                                Text(item.title)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select an item")
            }
        }
        
            

    private func addItem() {
        
        withAnimation {
            let newItem = ToDoItem(timestamp: Date(), title: newItemTitle)
            modelContext.insert(newItem)
            newItemTitle = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func printItemInfo(item: ToDoItem)-> some View{
        VStack(alignment: .leading){
            Text("Tittle: \n \(item.title)")
            Text("Timestamp: \n \(item.timestamp)")
            if let deadline = item.deadline{
                Text("Deadline: \n \(deadline)")
            }
            Text("Is Done?  \(item.isDone)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
