//
//  CategoryCardPlus.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct CardPlus: View {
    
    var name: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Image(systemName: "plus")
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    CardPlus(name: "Sci-Fi")
}
