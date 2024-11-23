//
//  MemberListView.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct MemberListView: View {
    
    @StateObject var viewModel = MemberViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Members")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                List {
                    ForEach(viewModel.members) { member in
                        NavigationLink(destination: MemberDetailView(viewModel: viewModel)
                            .onAppear {viewModel.detailLoad(member: member)}) {
                            Text("\(member.name)")
                        }
                    }
                    .onDelete(perform: viewModel.deleteMember)
                }
                .navigationDestination(isPresented: $viewModel.isAddViewActive) {
                    AddMemberView(viewModel: viewModel)
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addMemberPressed()
                    } label: {
                        HStack(spacing: 5) {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.showMembers()
            }
        }
    }

}

#Preview {
    MemberListView()
}
