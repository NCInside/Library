//
//  MembersRepository.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation
import SQLite

class MembersRepository {
    
    private let db: Connection
    
    init(db: Connection = DatabaseService.shared.getConnection()) {
        self.db = db
        setupTable()
    }
    
    static let table: Table = Table("Members")
    static let id: SQLite.Expression<Int64> = Expression<Int64>("id")
    static let name: SQLite.Expression<String> = Expression<String>("name")
    static let email: SQLite.Expression<String> = Expression<String>("email")
    static let address: SQLite.Expression<String> = Expression<String>("address")
    
    private func setupTable() {
        
        do {
            try db.run(Self.table.create(ifNotExists: true) { t in
                t.column(Self.id, primaryKey: .autoincrement)
                t.column(Self.name, unique: true)
                t.column(Self.email)
                t.column(Self.address)
            })
        } catch {
            print("\(error)")
        }
        
    }
    
    func create(_ item: Member) -> Int64? {
        
        do {
            try db.run(Self.table.insert(Self.name <- item.name, Self.email <- item.email, Self.address <- item.address))
            return db.lastInsertRowid
        } catch {
            print("\(error)")
            return nil
        }
        
    }
    
    func readAll() -> [Member] {
        
        var members: [Member] = []
        
        do {
            let membersRowIterator = try db.prepareRowIterator(Self.table)
            for member in try Array(membersRowIterator) {
                members.append(Member(id: member[Self.id], name: member[Self.name], email: member[Self.email], address: member[Self.address]))
            }
        } catch {
            print("\(error)")
        }
        
        return members
        
    }
    
    func update(_ item: Member) {
        
        do {
            let member = Self.table.filter(Self.id == item.id)
            try db.run(member.update(Self.name <- item.name, Self.email <- item.email, Self.address <- item.address))
        } catch {
            print("\(error)")
        }
        
    }
    
    func delete(id: Int64) {
        
        do {
            let member = Self.table.filter(Self.id == id)
            try db.run(member.delete())
        } catch {
            print("\(error)")
        }
        
    }
    
}
