//
//  Item.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-22.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
