//
//  TodoListViewModel.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-22.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift

class TodoListViewModel {
    let realm = try! Realm()
    var todoItems: Results<Item>? // list of items
    
    // delete item
    func delete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error deleting item, \(error)")
        }
    }
    
    // save item
    func save(name: String, currentCategory: Category) {
        do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = name
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
    }
    
    // set item as done
    func setDone(item: Item) {
        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error saving done status, \(error)")
        }
    }
}
