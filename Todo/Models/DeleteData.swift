//
//  DayData.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-27.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift

class DeleteData: Object{
    @objc dynamic var year: Int = -1
    @objc dynamic var month: Int = -1
    @objc dynamic var week: Int = -1
    @objc dynamic var weekday: Int = -1
    @objc dynamic var day: Int = -1
    @objc dynamic var hour: Int = -1
    
    convenience init(year: Int, month: Int, week: Int, weekday: Int, day: Int, hour: Int){
        self.init()
        self.year = year
        self.month = month
        self.week = week
        self.weekday = weekday
        self.day = day
        self.hour = hour
    }
}
