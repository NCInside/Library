//
//  CategoryListView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct CategoryListView: View {
    
    @StateObject var viewModel = CategoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Categories")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                List {
                    ForEach(viewModel.categories) { category in
                        NavigationLink(destination: CategoryDetailView(viewModel: viewModel)
                            .onAppear {viewModel.detailLoad(category: category)}) {
                            Text("\(category.name)")
                        }
                    }
                    .onDelete(perform: viewModel.deleteCategory)
                }
                .navigationDestination(isPresented: $viewModel.isAddViewActive) {
                    AddCategoryView(viewModel: viewModel)
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addCategoryPressed()
                    } label: {
                        HStack(spacing: 5) {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.showCategories()
            }
        }
    }

}

#Preview {
    CategoryListView()
}
