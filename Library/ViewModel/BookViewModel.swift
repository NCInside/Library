//
//  BookViewModel.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation

class BookViewModel: ObservableObject {
    
    @Published var books: [Book] = []
    @Published var categories: [Category] = []
    
    // Filter related
    @Published var initialSelectedCategories: [Category] = []
    @Published var selectedCategories: [Category] = []
    @Published var tempSelectedCategories: [Category] = []
    @Published var isFilterPresented: Bool = false
    
    // Add related
    @Published var title: String = ""
    @Published var publicationYear: String = ""
    @Published var page: String = ""
    @Published var initialAddedCategories: [Category] = []
    @Published var tempAddedCategories: [Category] = []
    @Published var addedCategories: [Category] = []
    @Published var isAddViewActive: Bool = false
    @Published var isCategoryPresented: Bool = false
    
    // Detail related
    @Published var selectedBook: Book?
    @Published var isShowingAlert: Bool = false
    
    private let bookRepo = BooksRepository()
    private let categoryRepo = CategoriesRepository()
    private let bookCategoryRepo = BooksCategoriesRepository()
    
    // Filter related start
    
    func filterPressed() {
        categories = categoryRepo.readAll()
        tempSelectedCategories = initialSelectedCategories
        isFilterPresented.toggle()
    }
    
    func cancelFilterPressed() {
        tempSelectedCategories.removeAll()
        isFilterPresented.toggle()
    }
    
    func doneFilterPressed() {
        selectedCategories = tempSelectedCategories
        initialSelectedCategories = tempSelectedCategories
        tempSelectedCategories.removeAll()
        
        if selectedCategories.isEmpty {
            books = bookRepo.readAll()
        }
        else {
            let selectedCategoryIds = selectedCategories.map { $0.id }
            books = bookRepo.readAll().filter { book in
                let bookCategories = bookCategoryRepo.readAllFromBook(id: book.id).map { $0.categoryId }
                return selectedCategoryIds.allSatisfy { bookCategories.contains($0) }
            }
        }
        
        isFilterPresented.toggle()
    }
    
    func addSelectedCategories(category: Category) {
        if !tempSelectedCategories.contains(where: { $0.id == category.id }) {
            tempSelectedCategories.append(category)
        }
    }
    
    func removeSelectedCategories(category: Category) {
        tempSelectedCategories.removeAll(where: { $0.id == category.id })
    }
    
    // Filter related end
    
    // Add related start
    
    func addBookPressed() {
        title = ""
        publicationYear = ""
        page = ""
        addedCategories.removeAll()
        isAddViewActive.toggle()
    }
    
    func addCategoryPressed() {
        tempAddedCategories = addedCategories
        categories = categoryRepo.readAll()
        isCategoryPresented.toggle()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        addedCategories.remove(atOffsets: offsets)
    }
    
    func addBook() {
        if title.isEmpty || publicationYear.isEmpty || page.isEmpty {
            return
        }
        
        if let intPublicationYear = Int64(publicationYear), let intPage = Int64(page) {
            let book = Book(id: 0, title: title, publicationYear: intPublicationYear, page: intPage, memberId: nil)
            
            if let bookId = bookRepo.create(book) {
                
                for category in addedCategories {
                    bookCategoryRepo.create(bookId: bookId, categoryId: category.id)
                }
                
                books.append(Book(id: bookId, title: book.title, publicationYear: book.publicationYear, page: book.page, memberId: book.memberId))
                isAddViewActive.toggle()
            }
            
        }
    }
    
    func cancelAddPressed() {
        tempAddedCategories.removeAll()
        isCategoryPresented.toggle()
    }
    
    func doneAddPressed() {
        addedCategories = tempAddedCategories
        tempAddedCategories.removeAll()
        isCategoryPresented.toggle()
    }
    
    func addAddedCategories(category: Category) {
        if !tempAddedCategories.contains(where: { $0.id == category.id }) {
            tempAddedCategories.append(category)
        }
    }
    
    func removeAddedCategories(category: Category) {
        tempAddedCategories.removeAll(where: { $0.id == category.id })
    }
    
    // Add related end
    
    // Detail related start
    
    func detailLoad(book: Book) {
        
        selectedBook = book
        title = book.title
        publicationYear = String(book.publicationYear)
        page = String(book.page)
        initialAddedCategories.removeAll()

        addedCategories = []
        for entry in bookCategoryRepo.readAllFromBook(id: book.id) {
            let category = categoryRepo.read(id: entry.categoryId)
            initialAddedCategories.append(category!)
            addedCategories.append(category!)
        }
        
    }
    
    func showAlert() {
        isShowingAlert.toggle()
    }
    
    func deleteCategoryDetail(at offsets: IndexSet) {
        addedCategories.remove(atOffsets: offsets)
        bookCategoryRepo.delete(bookId: selectedBook!.id, categoryId: addedCategories[offsets.first!].id)
    }
    
    func updateBook() {
        if title.isEmpty || publicationYear.isEmpty || page.isEmpty {
            return
        }
        
        if let intPublicationYear = Int64(publicationYear), let intPage = Int64(page) {
            
            let book = Book(id: selectedBook!.id, title: title, publicationYear: intPublicationYear, page: intPage, memberId: selectedBook!.memberId)
            bookRepo.update(book)
            
            let newCategories = addedCategories.filter { category in
                !initialAddedCategories.contains(category)
            }
            for category in newCategories {
                bookCategoryRepo.create(bookId: book.id, categoryId: category.id)
            }

            let removedCategories = initialAddedCategories.filter { category in
                !addedCategories.contains(category)
            }
            for category in removedCategories {
                bookCategoryRepo.delete(bookId: book.id, categoryId: category.id)
            }
                        
        }
    }
    
    // Detail related end
    
    func showBooks() {
        if selectedCategories.isEmpty {
            books = bookRepo.readAll()
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        bookRepo.delete(id: books[offsets.first!].id)
        books.remove(atOffsets: offsets)
    }
    
}
