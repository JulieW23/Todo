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
    
    enum timeFrame: String {
        case day = "day"
        case week = "week"
        case month = "month"
        case year = "year"
    }
    
    func loadStats(for timeFrame: timeFrame) {
        // clear array
        itemsDone = []
        switch timeFrame {
        case .day:
            for _ in 0..<24 {
                itemsDone.append(Double(arc4random_uniform(10)))
            }
        case .week:
            for _ in 0..<7 {
                itemsDone.append(Double(arc4random_uniform(10)))
            }
        case .month:
            for _ in 0..<30 {
                itemsDone.append(Double(arc4random_uniform(10)))
            }
        case .year:
            for _ in 0..<12 {
                itemsDone.append(Double(arc4random_uniform(10)))
            }
        }
    }
}
