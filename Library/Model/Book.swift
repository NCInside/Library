//
//  Book.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation

struct Book: Identifiable {
    let id: Int64
    let title: String
    let publicationYear: Int64
    let page: Int64
    let memberId: Int64?
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}
