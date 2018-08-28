//
//  ActivityViewModel.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-24.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import Foundation
import RealmSwift

class ActivityViewModel {
    var itemsDone: [Double] = []
    let realm = try! Realm()
    
    enum timeFrame {
        case day
        case month
        case year
    }
    
    func loadStats(for timeFrame: timeFrame) {
        // clear array
        itemsDone = []
        
        let now = Date()
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        if let year = component.year, let month = component.month, let day = component.day, let hour = component.hour {
            switch timeFrame {
            case .day:
                loadStatsHelper(xNumber: 24, filterString: "day == \(day)", timeFrame: .day)
            case .month:
                loadStatsHelper(xNumber: 31, filterString: "month == \(month)", timeFrame: .month)
            case .year:
                loadStatsHelper(xNumber: 12, filterString: "year == \(year)", timeFrame: .year)
            }
        }
    }
    
    func loadStatsHelper(xNumber: Int, filterString: String, timeFrame: timeFrame) {
        // fill itemsDone with the right number of slots
        for _ in 0..<xNumber {
            itemsDone.append(0)
        }
        // get data for the day/week/month/year
        let deletes = realm.objects(DeleteData.self).filter(filterString)
        // count entries into the correct slots
        for entry in deletes {
            switch timeFrame {
            case .day: itemsDone[entry.hour] += 1
            case .month: itemsDone[entry.day] += 1
            case .year: itemsDone[entry.month] += 1
            }
        }
    }
}
