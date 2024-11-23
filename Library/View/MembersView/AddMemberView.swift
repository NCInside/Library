//
//  AddMemberView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct AddMemberView: View {
    
    @ObservedObject var viewModel: MemberViewModel
    
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
                HStack {
                    Text("Email")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter email",  text: $viewModel.email)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                HStack {
                    Text("Address")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter address",  text: $viewModel.address)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 16)
                }
                .background(.white)
                Divider()
                    .padding(.leading)
                
                HStack {
                    Text("Books")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        viewModel.addBookPressed()
                    } label: {
                        Text("Edit")
                    }
                }
                .padding()
                .padding(.top, 36)
                
                List {
                    ForEach(viewModel.addedBooks) { book in
                        Text(book.title)
                    }
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addMember()
                    } label: {
                        HStack {
                            Text("Done")
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isBookPresented) {
                AddMemberBookView(viewModel: viewModel)
            }
            
            Spacer()
        }
    }
}

#Preview {
    AddMemberView(viewModel: MemberViewModel())
}
