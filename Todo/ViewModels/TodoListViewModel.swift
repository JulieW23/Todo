//
//  TodoListViewModel.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-22.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

class TodoListViewModel {
    private let realm = try! Realm()
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
        updateDeleteData()
    }
    
    // save item
    func save(name: String, currentCategory: Category) {
        do {
            try self.realm.write {
                let newItem = Item()
                let maxId = realm.objects(Item.self).map{$0.id}.max() ?? 0
                newItem.id = maxId + 1
                newItem.title = name
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
    }
    
    // update data after deleting
    func updateDeleteData() {
        let now = Date()
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([.year, .month, .weekOfYear, .weekday, .day, .hour], from: now)
        
        if let year = component.year, let month = component.month, let week = component.weekOfYear, let weekday = component.weekday, let day = component.day, let hour = component.hour {
            let entry = DeleteData(year: year, month: month, week: week, weekday: weekday, day: day, hour: hour)
            do {
                try realm.write {
                    realm.add(entry)
                }
            } catch {
                print("Error addint new delete data entry, \(error)")
            }
        }
    }
    
    // update item text
    func updateItemText(indexPath: IndexPath, newText: String) {
        do {
            try realm.write {
                if let itemToEdit = todoItems?[indexPath.row] {
                    itemToEdit.title = newText
                }
            }
        } catch {
            print("Error updating item text, \(error)")
        }
    }
    
    // update item reminder
    func setItemReminder(indexPath: IndexPath, reminderDate: Date? = nil) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // realm
        if let itemToEdit = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    if reminderDate != nil {
                        itemToEdit.reminder = reminderDate
                    } else {
                        itemToEdit.reminder = nil
                    }
                }
            } catch {
                print("Error updating item reminder, \(error)")
            }
            
            // notif
            // remove existing pending notif for the item if exists
            appDelegate.notifCenter?.removePendingNotificationRequests(withIdentifiers: [String(itemToEdit.id)])
            // add pending notif
            if reminderDate != nil {
                let content = UNMutableNotificationContent()
                content.title = "Reminder:"
                content.body = itemToEdit.title
                content.sound = UNNotificationSound.default()
                
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let request = UNNotificationRequest(identifier: String(itemToEdit.id), content: content, trigger: trigger)
                appDelegate.notifCenter?.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print("\(error)")
                    }
                })
            }
        }
    }
}
