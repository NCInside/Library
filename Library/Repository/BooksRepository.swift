//
//  BooksRepository.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation
import SQLite

class BooksRepository {
    
    private let db: Connection
    
    init(db: Connection = DatabaseService.shared.getConnection()) {
        self.db = db
        setupTable()
    }
    
    static let table: Table = Table("Books")
    static let id: SQLite.Expression<Int64> = Expression<Int64>("id")
    static let title: SQLite.Expression<String> = Expression<String>("title")
    static let publicationYear: SQLite.Expression<Int64> = Expression<Int64>("publication_year")
    static let page: SQLite.Expression<Int64> = Expression<Int64>("page")
    static let memberId: SQLite.Expression<Int64?> = Expression<Int64?>("member_id")
    
    private func setupTable() {
        
        do {
            try db.run(Self.table.create(ifNotExists: true) { t in
                t.column(Self.id, primaryKey: .autoincrement)
                t.column(Self.title)
                t.column(Self.publicationYear)
                t.column(Self.page)
                t.column(Self.memberId)
                t.foreignKey(Self.memberId, references: MembersRepository.table, MembersRepository.id, delete: .setNull)
            })
        } catch {
            print("\(error)")
        }
        
    }
    
    func create(_ item: Book) -> Int64? {
        
        do {
            try db.run(Self.table.insert(Self.title <- item.title, Self.publicationYear <- item.publicationYear, Self.page <- item.page, Self.memberId <- item.memberId))
            return db.lastInsertRowid
        } catch {
            print("\(error)")
            return nil
        }
        
    }
    
    func readAll() -> [Book] {
        
        var books: [Book] = []
        
        do {
            let booksRowIterator = try db.prepareRowIterator(Self.table)
            for book in try Array(booksRowIterator) {
                books.append(Book(id: book[Self.id], title: book[Self.title], publicationYear: book[Self.publicationYear], page: book[Self.page], memberId: book[Self.memberId]))
            }
        } catch {
            print("\(error)")
        }
        
        return books
        
    }
    
    func readAllFromMember(id: Int64) -> [Book] {
        
        var books: [Book] = []
        
        do {
            let booksRowIterator = try db.prepareRowIterator(Self.table.filter(Self.memberId == id))
            for book in try Array(booksRowIterator) {
                books.append(Book(id: book[Self.id], title: book[Self.title], publicationYear: book[Self.publicationYear], page: book[Self.page], memberId: book[Self.memberId]))
            }
        } catch {
            print("\(error)")
        }
        
        return books
        
    }
    
    func update(_ item: Book) {
        
        do {
            let book = Self.table.filter(Self.id == item.id)
            try db.run(book.update(Self.title <- item.title, Self.publicationYear <- item.publicationYear, Self.page <- item.page, Self.memberId <- item.memberId))
        } catch {
            print("\(error)")
        }
        
    }
    
    func delete(id: Int64) {
        
        do {
            let book = Self.table.filter(Self.id == id)
            try db.run(book.delete())
        } catch {
            print("\(error)")
        }
        
    }
    
}
