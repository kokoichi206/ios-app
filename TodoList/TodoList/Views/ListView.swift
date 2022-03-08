//
//  ListView.swift
//  TodoList
//
//  Created by Takahiro Tominaga on 2022/03/08.
//

import SwiftUI

struct ListView: View {
    
    @State var items: [String] = [
        "This is the first title!",
        "This is the second!",
        "Third!"
    ]
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                ListRowView(title: item)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Todo List 😄")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Add", destination: Text("Destination"))
        )
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
