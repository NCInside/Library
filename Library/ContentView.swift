//
//  ContentView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Members", systemImage: "person.fill") {
                MemberListView()
            }
            Tab("Books", systemImage: "book.fill") {
                BookListView()
            }
            Tab("Categories", systemImage: "tag.fill") {
                CategoryListView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
