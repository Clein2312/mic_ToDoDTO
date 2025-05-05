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
    @StateObject var viewModel: ToDoItemViewModel
    @State private var isLoading: Bool = false
    @State private var selectedItem: ToDoItem?
    
    var body: some View {
        
            NavigationSplitView {
                VStack{
                    Text("ToDo App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.tint)
                    
                    HStack {
                        TextField("New ToDO item...", text: $newItemTitle)
                            .onSubmit {
                                addItem()
                            }
                            .padding()
                            .cornerRadius(8)
                            .font(.headline)
                        
                        Button(action: addItem){
                            Image(systemName: "plus").font(.title2)
                        }.disabled(newItemTitle.isEmpty)
                    }.padding(.horizontal)
                    
                    
                    
                    Divider()
                    
                    if isLoading {
                        ProgressView("Loading items...")
                            .padding()
                    }else{
                        
                        List {
                            ForEach(items) { item in
                                NavigationLink(value:item) {
                                    ToDoItemRow(item: item)
                                }
                            }
                            .   onDelete(perform: deleteItems)
                        }
                    }
                }
                        .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: refreshItems) {
                            Label("Refresh", systemImage: "arrow.clockwise")
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
    
    private func refreshItems() {
        isLoading = true
        Task{
            await viewModel.fetchToDoItems()
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView( viewModel: ToDoItemViewModel())
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
