//
//  CategoryViewModel.swift
//  Library
//
//  Created by Nicholas Christian Irawan on 23/11/24.
//

import Foundation

class CategoryViewModel: ObservableObject {
    
    @Published var categories: [Category] = []
        
    // Add related
    @Published var name: String = ""
    @Published var isAddViewActive: Bool = false
    
    // Detail related
    @Published var selectedCategory: Category?
    @Published var isShowingAlert: Bool = false
    
    private let categoryRepo = CategoriesRepository()
    
    // Add related start
    
    func addCategoryPressed() {
        name = ""
        isAddViewActive.toggle()
    }
    
    func addCategory() {
        
        if name.isEmpty {
            return
        }
        
        if let categoryId = categoryRepo.create(Category(id: 0, name: name)) {
            categories.append(Category(id: categoryId, name: name))
            isAddViewActive.toggle()
        }
        
    }
    
    // Add related end
    
    // Detail related start
    
    func detailLoad(category: Category) {
        
        selectedCategory = category
        name = category.name
        
    }
    
    func showAlert() {
        isShowingAlert.toggle()
    }
    
    func updateCategory() {
        if name.isEmpty {
            return
        }
        
        let category = Category(id: selectedCategory!.id, name: name)
        categoryRepo.update(category)
    }
    
    // Detail related end
    
    func showCategories() {
        categories = categoryRepo.readAll()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        categoryRepo.delete(id: categories[offsets.first!].id)
        categories.remove(atOffsets: offsets)
    }
    
}
