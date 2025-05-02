//
//  ToDoItemDetailView.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 30.04.25.
//

import SwiftUI

struct ToDoItemDetailView: View {
    @State var toDoItem: ToDoItem
    @State var date: Date = Date()
    @State var showDatePicker: Bool = false
    @State var selectedDate: Date? = nil
    
    var body: some View {
        VStack(){
            Text(toDoItem.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()

            HStack {
                Toggle("Mark as done", isOn: $toDoItem.isDone).labelsHidden()
                
                Text("\(toDoItem.isDone ? "Done" : "Not done")")
            }
            
            
            HStack {
                
                Button("Deadline: ",systemImage: "calendar"){
                    showDatePicker.toggle()
                }
                
                if let deadline = toDoItem.deadline {
                    Text(deadline,style: .date)
                }else{
                    Text("No Date")
                }
                
            }
            if showDatePicker {
                DatePicker("Select Deadline", selection: $date).datePickerStyle(.graphical)
                    .onDisappear {
                        toDoItem.deadline = date
                        showDatePicker = false
                    }
                HStack{
                    Button("Done"){
                        showDatePicker.toggle()
                    }
                    Button("Remove Date"){
                        
                        toDoItem.deadline = nil
                        
                    }
                }
            }else{
                //if deadline is set: show delete deadline
                if let deadline = toDoItem.deadline {
                    Button("Remove Deadline"){
                        toDoItem.deadline = nil
                    }
                }
            }
            
            
            Spacer()
        }
    }
}

#Preview {
    ToDoItemDetailView(toDoItem: ToDoItem(timestamp: .now, id: .init(), title: "Example To Do"))
    //deadline: .now))
}
