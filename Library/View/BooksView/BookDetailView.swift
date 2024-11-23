//
//  BookDetailView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct BookDetailView: View {
    
    @ObservedObject var viewModel: BookViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Title")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter title",  text: $viewModel.title)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                HStack {
                    Text("Publication Year")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter year",  text: $viewModel.publicationYear)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                HStack {
                    Text("Page Count")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter page",  text: $viewModel.page)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                
                HStack {
                    Text("Categories")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        viewModel.addCategoryPressed()
                    } label: {
                        Text("Edit")
                    }
                }
                .padding()
                .padding(.top, 36)
                
                List {
                    ForEach(viewModel.addedCategories) { category in
                        Text(category.name)
                    }
                    .onDelete(perform: viewModel.deleteCategoryDetail)
                }
                .alert("Are you sure?", isPresented: $viewModel.isShowingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        viewModel.updateBook()
                    }
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showAlert()
                    } label: {
                        HStack {
                            Text("Edit")
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isCategoryPresented) {
                AddBookCategoryView(viewModel: viewModel)
            }
            
            Spacer()
        }
    }
}

#Preview {
    BookDetailView(viewModel: BookViewModel())
}
