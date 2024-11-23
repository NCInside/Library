//
//  AddMemberBookView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct AddMemberBookView: View {
    
    @ObservedObject var viewModel: MemberViewModel
    
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
            
            Text("Books")
                .font(.title2)
                .bold()
                .padding(.bottom)
            
            ScrollView(.horizontal) {
                HStack(spacing: 6) {
                    ForEach(viewModel.tempAddedBooks) { book in
                        CardX(name: book.title)
                            .onTapGesture {
                                viewModel.removeAddedBooks(book: book)
                            }
                    }
                }
            }
            .frame(maxHeight: 24)
            .padding(.bottom, 24)
            
            ScrollView {
                ForEach(viewModel.books) { book in
                    CardPlus(name: book.title)
                        .onTapGesture {
                            viewModel.addAddedBooks(book: book)
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddMemberBookView(viewModel: MemberViewModel())
}
