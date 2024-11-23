//
//  BookListView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct BookListView: View {
    
    @StateObject var viewModel = BookViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Books")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        viewModel.filterPressed()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundStyle(.black)
                    }
                    .sheet(isPresented: $viewModel.isFilterPresented) {
                        BookFilterView(viewModel: viewModel)
                    }
                }
                
                List {
                    ForEach(viewModel.books) { book in
                        NavigationLink(destination: BookDetailView(viewModel: viewModel)
                            .onAppear { viewModel.detailLoad(book: book)}) {
                            Text("\(book.title)")
                        }
                    }
                    .onDelete(perform: viewModel.deleteBook)
                }
                .navigationDestination(isPresented: $viewModel.isAddViewActive) {
                    AddBookView(viewModel: viewModel)
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addBookPressed()
                    } label: {
                        HStack(spacing: 5) {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.showBooks()
            }
        }
    }
}

#Preview {
    BookListView()
}
