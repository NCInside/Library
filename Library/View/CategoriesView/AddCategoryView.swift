//
//  AddCategoryView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct AddCategoryView: View {
    
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                
                HStack {
                    Text("Name")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter name",  text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addCategory()
                    } label: {
                        HStack {
                            Text("Done")
                        }
                    }
                }
            }
            
            Spacer()
        }

    }
}

#Preview {
    AddCategoryView(viewModel: CategoryViewModel())
}
