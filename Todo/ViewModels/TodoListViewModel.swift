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
        updateData()
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
    
    // update data after deleting
    func updateData() {
        let now = Date()
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        
        if let year = component.year, let month = component.month, let day = component.day, let hour = component.hour {
            let entry = DeleteData(year: year, month: month, day: day, hour: hour)
            do {
                try realm.write {
                    realm.add(entry)
                }
            } catch {
                print("Error addint new delete data entry, \(error)")
            }
        }
    }
}
