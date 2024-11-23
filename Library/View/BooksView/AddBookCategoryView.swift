//
//  AddBookCategoryView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct AddBookCategoryView: View {
    
    @ObservedObject var viewModel: BookViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    viewModel.cancelAddPressed()
                } label: {
                    HStack(spacing: 5) {
                        Text("Cancel")
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.doneAddPressed()
                } label: {
                    HStack(spacing: 5) {
                        Text("Done")
                    }
                }
            }
            .padding(.bottom, 24)
            
            Text("Categories")
                .font(.title2)
                .bold()
                .padding(.bottom)
            
            ScrollView(.horizontal) {
                HStack(spacing: 6) {
                    ForEach(viewModel.tempAddedCategories) { category in
                        CardX(name: category.name)
                            .onTapGesture {
                                viewModel.removeAddedCategories(category: category)
                            }
                    }
                }
            }
            .frame(maxHeight: 24)
            .padding(.bottom, 24)
            
            ScrollView {
                ForEach(viewModel.categories) { category in
                    CardPlus(name: category.name)
                        .onTapGesture {
                            viewModel.addAddedCategories(category: category)
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddBookCategoryView(viewModel: BookViewModel())
}
