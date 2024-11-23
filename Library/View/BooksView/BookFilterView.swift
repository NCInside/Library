//
//  CategoryFilterView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct BookFilterView: View {
    
    @ObservedObject var viewModel: BookViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    viewModel.cancelFilterPressed()
                } label: {
                    HStack(spacing: 5) {
                        Text("Cancel")
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.doneFilterPressed()
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
                    ForEach(viewModel.tempSelectedCategories) { category in
                        CardX(name: category.name)
                            .onTapGesture {
                                viewModel.removeSelectedCategories(category: category)
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
                            viewModel.addSelectedCategories(category: category)
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    BookFilterView(viewModel: BookViewModel())
}
