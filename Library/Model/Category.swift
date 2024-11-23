//
//  Category.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation

struct Category: Identifiable {
    let id: Int64
    let name: String
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
