//
//  MemberViewModel.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation

class MemberViewModel: ObservableObject {
    
    @Published var members: [Member] = []
    @Published var books: [Book] = []
    
    // Add related
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var initialAddedBooks: [Book] = []
    @Published var tempAddedBooks: [Book] = []
    @Published var addedBooks: [Book] = []
    @Published var isAddViewActive: Bool = false
    @Published var isBookPresented: Bool = false
    
    // Detail related
    @Published var selectedMember: Member?
    @Published var isShowingAlert: Bool = false
    
    private let memberRepo = MembersRepository()
    private let bookRepo = BooksRepository()
    
    // Add related start
    
    func addMemberPressed() {
        name = ""
        email = ""
        address = ""
        addedBooks.removeAll()
        isAddViewActive.toggle()
    }
    
    func addBookPressed() {
        tempAddedBooks = addedBooks
        books = bookRepo.readAll()
        books = books.filter( {$0.memberId == nil} )
        isBookPresented.toggle()
    }
    
    func addMember() {
        if name.isEmpty || email.isEmpty || address.isEmpty {
            return
        }
        
        let member = Member(id: 0, name: name, email: email, address: address)
        
        if let memberId = memberRepo.create(member) {
            
            for book in addedBooks {
                bookRepo.update(Book(id: book.id, title: book.title, publicationYear: book.publicationYear, page: book.page, memberId: memberId))
            }
            
            members.append(Member(id: memberId, name: name, email: email, address: address))
            isAddViewActive.toggle()
        }
    }
    
    func cancelAddPressed() {
        tempAddedBooks.removeAll()
        isBookPresented.toggle()
    }
    
    func doneAddPressed() {
        addedBooks = tempAddedBooks
        tempAddedBooks.removeAll()
        isBookPresented.toggle()
    }
    
    func addAddedBooks(book: Book) {
        if !tempAddedBooks.contains(where: { $0.id == book.id }) {
            tempAddedBooks.append(book)
        }
    }
    
    func removeAddedBooks(book: Book) {
        tempAddedBooks.removeAll(where: { $0.id == book.id })
    }
    
    // Add related end
    
    // Detail related start
    
    func detailLoad(member: Member) {
        
        selectedMember = member
        name = member.name
        email = member.email
        address = member.address
        books = bookRepo.readAll()
        books = books.filter( {$0.memberId == nil} )
        initialAddedBooks.removeAll()
        
        addedBooks = []
        for book in bookRepo.readAllFromMember(id: member.id) {
            initialAddedBooks.append(book)
            addedBooks.append(book)
        }
        
    }
    
    func showAlert() {
        isShowingAlert.toggle()
    }
    
    func updateMember() {
        if name.isEmpty || email.isEmpty || address.isEmpty {
            return
        }
        
        let member = Member(id: selectedMember!.id, name: name, email: email, address: address)
        memberRepo.update(member)
        
        let newBooks = addedBooks.filter { book in
            !initialAddedBooks.contains(book)
        }
        for book in newBooks {
            bookRepo.update(Book(id: book.id, title: book.title, publicationYear: book.publicationYear, page: book.page, memberId: member.id))
        }

        let removedBooks = initialAddedBooks.filter { book in
            !addedBooks.contains(book)
        }
        for book in removedBooks {
            bookRepo.update(Book(id: book.id, title: book.title, publicationYear: book.publicationYear, page: book.page, memberId: nil))
        }
        
    }
    
    // Detail related end
    
    func showMembers() {
        members = memberRepo.readAll()
    }
    
    func deleteMember(at offsets: IndexSet) {
        memberRepo.delete(id: members[offsets.first!].id)
        members.remove(atOffsets: offsets)
    }
    
}
