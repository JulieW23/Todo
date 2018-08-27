//
//  CategoryViewModel.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-22.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    let realm = try! Realm()
    var categories: Results<Category>? // list of categories
    
    // save a category
    func save(name: String, colour: String) {
        let category = Category()
        category.name = name
        category.colour = colour
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    // load all categories
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    // delete a category and all of it's items
    func delete(category: Category) {
        do {
            for item in category.items {
                try self.realm.write {
                    self.realm.delete(item)
                }
            }
            try self.realm.write {
                self.realm.delete(category)
            }
        } catch {
            print ("Error deleting category")
        }
    }
    
    func updateColour(indexPath: IndexPath, hexValue: String) {
        let categoryName = categories?[indexPath.row].name
        if let specificCategory = realm.object(ofType: Category.self, forPrimaryKey: categoryName) {
            do {
                try realm.write {
                    specificCategory.colour = hexValue
                }
            } catch {
                print("error updating category colour, \(error)")
            }
        }
    }
}
