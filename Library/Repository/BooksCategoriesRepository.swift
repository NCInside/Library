//
//  BooksCategoriesRepository.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation
import SQLite

class BooksCategoriesRepository {
    
    private let db: Connection
    
    init(db: Connection = DatabaseService.shared.getConnection()) {
        self.db = db
        setupTable()
    }
    
    static let table: Table = Table("BooksCategories")
    static let bookId: SQLite.Expression<Int64> = Expression<Int64>("book_id")
    static let categoryId: SQLite.Expression<Int64> = Expression<Int64>("category_id")
    
    private func setupTable() {
        
        do {
            try db.run(Self.table.create(ifNotExists: true) { t in
                t.column(Self.bookId)
                t.column(Self.categoryId)
                t.primaryKey(Self.bookId, Self.categoryId)
                t.foreignKey(Self.bookId, references: BooksRepository.table, BooksRepository.id, delete: .cascade)
                t.foreignKey(Self.categoryId, references: CategoriesRepository.table, CategoriesRepository.id, delete: .cascade)
            })
        } catch {
            print("\(error)")
        }
        
    }
    
    func create(bookId: Int64, categoryId: Int64) {
        
        do {
            let exists = try db.pluck(Self.table.filter(Self.bookId == bookId && Self.categoryId == categoryId)) != nil
                    
            if !exists {
                try db.run(Self.table.insert(Self.bookId <- bookId, Self.categoryId <- categoryId))
            }
        } catch {
            print("\(error)")
        }
        
    }
    
    func readAll() -> [(bookId: Int64, categoryId: Int64)] {
        
        var entries: [(bookId: Int64, categoryId: Int64)] = []
        
        do {
            let rows = try db.prepareRowIterator(Self.table)
            for row in try Array(rows) {
                entries.append((bookId: row[Self.bookId], categoryId: row[Self.categoryId]))
            }
        } catch {
            print("\(error)")
        }
        
        return entries
        
    }
    
    func readAllFromBook(id: Int64) -> [(bookId: Int64, categoryId: Int64)] {
        
        var entries: [(bookId: Int64, categoryId: Int64)] = []
        
        do {
            let rows = try db.prepareRowIterator(Self.table.filter(Self.bookId == id))
            for row in try Array(rows) {
                entries.append((bookId: row[Self.bookId], categoryId: row[Self.categoryId]))
            }
        } catch {
            print("\(error)")
        }
        
        return entries
        
    }
    
    func readAllFromCategory(id: Int64) -> [(bookId: Int64, categoryId: Int64)] {
        
        var entries: [(bookId: Int64, categoryId: Int64)] = []
        
        do {
            let rows = try db.prepareRowIterator(Self.table.filter(Self.categoryId == id))
            for row in try Array(rows) {
                entries.append((bookId: row[Self.bookId], categoryId: row[Self.categoryId]))
            }
        } catch {
            print("\(error)")
        }
        
        return entries

        
    }
    
    func delete(bookId: Int64, categoryId: Int64) {
        
        do {
            let entry = Self.table.filter(Self.bookId == bookId && Self.categoryId == categoryId)
            try db.run(entry.delete())
        } catch {
            print("\(error)")
        }
        
    }
    
}
