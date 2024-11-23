//
//  DatabaseService.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()
    private var db: Connection!

    private init() {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/librarydb.sqlite3")
            
            try db.execute("PRAGMA foreign_keys = ON;")
        } catch {
            print("Database connection error: \(error)")
        }
    }

    func getConnection() -> Connection {
        return db
    }

    func setConnection(_ connection: Connection) {
        self.db = connection
    }
}
