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
        VStack(alignment: .leading){
            Text(toDoItem.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading)
            
            Grid {
                GridRow{
                    Toggle("Mark as done", isOn: $toDoItem.isDone).labelsHidden()
                    
                    Spacer()
                        .frame(width: 100)
                    
                    
                    Text("\(toDoItem.isDone ? "Done" : "Not done")")
                    
                    Spacer()
                }
                .padding(.vertical)
                
                GridRow{
                    Text("Priority: ")
                    
                    switch toDoItem.priority {
                    case .high:
                        Image(systemName: "exclamationmark.circle.fill").foregroundStyle(Color.red)
                    case .medium:
                        Image(systemName: "circle.fill").foregroundStyle(Color.green)
                        
                    case .low:
                        Image(systemName: "arrow.down.circle.fill").foregroundStyle(Color.blue)
                        
                    }
                    
                    Spacer(minLength: 2)
                    
                    
                    
                    Picker("Priority", selection: $toDoItem.priority){
                        ForEach(ToDoItem.Priority.allCases){
                            prio in Text(prio.rawValue)
                        }
                    }.foregroundStyle(Color.black)
                    
                    //Spacer()
                }.padding(.vertical)
                
                GridRow{
                    Button("Deadline: ",systemImage: "calendar"){
                        showDatePicker.toggle()
                    }
                    Spacer ()
                    if let deadline = toDoItem.deadline {
                        Text(deadline,style: .date)
                    }else{
                        Text("No Date")
                    }
                }.padding(.vertical)
                
                
                GridRow{
                    if showDatePicker {
                        DatePicker("Select Deadline", selection: $date)
                            .datePickerStyle(.graphical)
                            .onDisappear {
                                toDoItem.deadline = date
                                showDatePicker = false
                            }
                        GridRow{
                            Button("Done"){
                                showDatePicker.toggle()
                            }
                            Button("Remove Date"){
                                
                                toDoItem.deadline = nil
                                
                            }
                        }
                    }
                    else{
                        GridRow{
                            //if deadline is set: show delete deadline
                            if toDoItem.deadline != nil {
                                Button("Remove Deadline"){
                                    toDoItem.deadline = nil
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
            }
            
        }
    }
}

#Preview {
    ToDoItemDetailView(toDoItem: ToDoItem(timestamp: .now, id: .init(), title: "Example To Do"))
    //deadline: .now))
}
