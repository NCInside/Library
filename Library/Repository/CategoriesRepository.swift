//
//  CategoryRepository.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation
import SQLite

class CategoriesRepository {
    
    private let db: Connection
    
    init(db: Connection = DatabaseService.shared.getConnection()) {
        self.db = db
        setupTable()
    }
    
    static let table: Table = Table("Categories")
    static let id: SQLite.Expression<Int64> = Expression<Int64>("id")
    static let name: SQLite.Expression<String> = Expression<String>("name")
    
    private func setupTable() {
        
        do {
            try db.run(Self.table.create(ifNotExists: true) { t in
                t.column(Self.id, primaryKey: .autoincrement)
                t.column(Self.name, unique: true)
            })
        } catch {
            print("\(error)")
        }
        
    }
    
    func create(_ item: Category) -> Int64? {
        
        do {
            try db.run(Self.table.insert(Self.name <- item.name))
            return db.lastInsertRowid
        } catch {
            print("\(error)")
            return nil
        }
        
    }
    
    func read(id: Int64) -> Category? {
        
        do {
            let query = Self.table.filter(Self.id == id)
            if let categoryRow = try db.pluck(query) {
                return Category(id: categoryRow[Self.id], name: categoryRow[Self.name])
            }
        } catch {
            print("\(error)")
        }
        
        return nil
    }
    
    func readAll() -> [Category] {
        
        var categories: [Category] = []
        
        do {
            let categoriesRowIterator = try db.prepareRowIterator(Self.table)
            for category in try Array(categoriesRowIterator) {
                categories.append(Category(id: category[Self.id], name: category[Self.name]))
            }
        } catch {
            print("\(error)")
        }
        
        return categories
        
    }
    
    func update(_ item: Category) {
        
        do {
            let category = Self.table.filter(Self.id == item.id)
            try db.run(category.update(Self.name <- item.name))
        } catch {
            print("\(error)")
        }
        
    }
    
    func delete(id: Int64) {
        
        do {
            let category = Self.table.filter(Self.id == id)
            try db.run(category.delete())
        } catch {
            print("\(error)")
        }
        
    }
    
}
