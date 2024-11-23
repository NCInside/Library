//
//  CategoryCardX.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import SwiftUI

struct CardX: View {
    
    var name: String
    
    var body: some View {
        HStack {
            Text(name)
            Image(systemName: "xmark")
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    CardX(name: "Sci-Fi")
}
