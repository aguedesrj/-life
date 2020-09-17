//
//  ScheduleViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct ScheduleViewModel {
    var id: Int
    var date: String
    var dateDate: Date
    var hour: String
    var day: String
    var month: String
    var activity: String
    var description: String
    var categoryId: Int
    var categoryName: String
    var newSection: Bool
    
    init(id: Int, date: String, hour: String, day: String, month: String,
         activity: String,description: String, categoryId: Int,
         categoryName: String, dateDate: Date) {
        
        self.id = id
        self.date = date
        self.hour = hour
        self.day = day
        self.month = month
        self.activity = activity
        self.description = description
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.dateDate = dateDate
        self.newSection = false
    }
}
