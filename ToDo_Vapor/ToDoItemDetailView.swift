//
//  ToDoItemDetailView.swift
//  ToDo_Vapor
//
//  Created by Sarmiento Castrillon, Clein Alexander on 30.04.25.
//

import SwiftUI

struct ToDoItemDetailView: View {
    @State var toDoItem: ToDoItem
    @State private var date: Date = Date()
    @State private var showDatePicker: Bool = false
    
    @State private var selectedDate: Date? = nil
    
    
    var body: some View {
        VStack{
            HStack{
                Text(toDoItem.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top,30)
                
                
                Spacer()
            }.padding(.leading,30)
            
            Divider()
            
            HStack{
                Text("Priority: ")
                    .font(.title2)
                
                Picker("Priority", selection: $toDoItem.priority){
                    ForEach(ToDoItem.Priority.allCases){
                        prio in Text(prio.rawValue).font(.title2)
                    }
                    
                    
                    
                }
                .foregroundStyle(Color.black)
                .font(.title2)
                .pickerStyle(.segmented)
                
                Spacer()
                
            }.padding(.leading,30)
            
            Divider()
            
            HStack{
                Toggle("Mark as done", isOn: $toDoItem.isDone)
                    .labelsHidden()
                    .font(.title2)
                
                Text("\(toDoItem.isDone ? "Done" : "Not done")")
                    .font(.title2)
                
                Spacer()
                
            }.padding(.leading,30)
            
            Divider()
            
            HStack{
                Button("Deadline: ",systemImage: "calendar"){
                    showDatePicker.toggle()
                }.font(.title2)
                
                if let deadline = toDoItem.deadline {
                    Text(deadline,style: .date)
                        .frame(width: 150)
                        .font(.title2)
                }else{
                    Text("No Date").font(.title2)
                }
                
                Spacer()
                
            }.padding(.vertical,10)
                .padding(.leading,30)
            
            Button("Remove Date"){
                
                toDoItem.deadline = nil
            }.disabled(toDoItem.deadline == nil)
            
            HStack{
                if showDatePicker {
                    VStack{
                        DatePicker("Select Deadline", selection: $date)
                            .datePickerStyle(.graphical)
                            .onDisappear {
                                toDoItem.deadline = date
                                showDatePicker = false
                            }
                        HStack{
                            Button("Done"){
                                showDatePicker.toggle()
                            }
                            
                        }
                    }
                }
            }
            
            Divider()
            
            
            Spacer()
        }
    }
}
            
        
    


#Preview {
    ToDoItemDetailView(toDoItem: ToDoItem(timestamp: .now, id: .init(), title: "Example To Do"))
    //deadline: .now))
}
