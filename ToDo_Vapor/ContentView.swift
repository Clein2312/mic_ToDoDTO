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
    @State var viewModel: ToDoItemViewModel
    @State private var isLoading: Bool = false
    @State private var selectedItem: ToDoItem?
    @State private var isEditMode: Bool = false
    
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
                                //addItem_test()
                            }
                            .padding()
                            .cornerRadius(8)
                            .font(.headline)
                        
                        Button(action: addItem){
                        //Button(action: addItem_test){
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
                            .onDelete(perform: deleteItems)
                            
                            //.onDelete(perform: deleteItems_test)
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
                    ToolbarItem{
                        Button(action: deleteAllItems_test){
                            Label("Delete All", systemImage: "trash")
                        }
                    }
                }
                
                .navigationDestination(for: ToDoItem.self){ item in
                   ToDoItemDetailView(toDoItem: item)
                        .onDisappear {
                            // update
                            
                        }
                }
            } detail: {
                Text("Select an item")
            }
            .task{
                setupViewModel()
            }
        }
        
//MARK: API Synchronizatopm
    private func setupViewModel() {
        viewModel.onAppear(modelContext: modelContext)
        isLoading = true
        Task {
            await viewModel.fetchToDoItems()
            await MainActor.run {
                isLoading = false
            }
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
            
//MARK: Add an Item:
    
    private func addItem_test() {
        
        withAnimation {
            let newItem = ToDoItem(timestamp: Date(), title: newItemTitle)
            modelContext.insert(newItem)
            newItemTitle = ""
        }
    }
    
    private func addItem(){
        guard !newItemTitle.isEmpty else { return }
        
        withAnimation {
            let data = ToDoItemCreateDTO(
                title: newItemTitle
                
            )
            
            Task {
                isLoading = true
                await viewModel.createToDoItem(data: data)
                newItemTitle = ""
                isLoading = false
            }
        }
    }

    //MARK: Delete Items
    private func deleteItems_test(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                
            }
        }
    }
    
    private func deleteAllItems_test(){
        withAnimation{
            for item in items{
                modelContext.delete(item)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet){
        withAnimation {
            for index in offsets {
                deleteItem(items[index])
            }
        }
    }
    
    
    private func deleteItem(_ item: ToDoItem){
        Task {
            isLoading = true
            await viewModel.deleteToDoItem(toDoItem: item)
           
            isLoading = false
        }
    }
    
    // MARK: Fetch one item
    
    
    
    // MARK: Update one item
    
    
    
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
    var myViewModel = ToDoItemViewModel()
    ContentView( viewModel: myViewModel)
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
