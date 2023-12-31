//
//  ContentView.swift
//  Core data demo swiftui
//
//  Created by Carmen Lucas on 7/9/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "age", ascending: true)],
//                   predicate: NSPredicate(format: "name contains 'Joe'") ) var people: FetchedResults<
//        Person>
    @State var people = [Person]()
    @State var filterByText = ""
    var body: some View {
        VStack{
            Button(action: addPerson) {
                Label("Add person", systemImage: "plus")
            }
            TextField("Filter text", text: $filterByText)
//            { _ in
//                fetchData()
//            }
                .border(Color.black, width: 1)
                .padding()
            List {
                ForEach(people) {
                    person in
                    Text("\(person.name ?? "No name"), age: \(person.age)")
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                person.name = "Joe"
                                try! viewContext.save()
                            } label: {
                                Label("Mute", systemImage: "bell.slash.fill")
                            }
                            .tint(.indigo)

                            Button(role: .destructive) {
                                viewContext.delete(person)
                                try! viewContext.save()
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                }
            }
        }.onChange(of: filterByText) { _ in
            fetchData()
        }
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
    }
    func fetchData(){
        // create fetch request
        let request = Person.fetchRequest()
        
        // set sort descriptor and predicates
        request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
        request.predicate = NSPredicate(format: "name contains[c] %@", filterByText)
        
        // execute the fetch
        DispatchQueue.main.async {
            do {
                let results = try viewContext.fetch(request)
                // Update the state property
                
                self.people = results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func addPerson() {
        withAnimation {
            let newPerson = Person(context: viewContext)
            newPerson.name = "Tom"
            newPerson.age = Int64.random(in: 1...30)
            
            do {
                try viewContext.save()
            } catch {
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
