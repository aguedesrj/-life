//
//  Schedule.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Schedule {
    var id: Int
    var date: String
    var dateDate: Date
    var hour: String
    var activity: String
    var description: String
    var categoryId: Int
    var categoryName: String
    var day: String
    var month: String
    init(id: Int, date: String, hour: String, day: String, month: String,
         activity: String, description: String, categoryId: Int,
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
    }
}

extension Schedule {
    
    static func parse(json: [JSON]) -> [Schedule] {
        var listReturn: [Schedule] = []
        for item in json {
            let id = item["id"].intValue
            let date = item["data"].stringValue
            let hour = item["hora"].stringValue
            let day = item["dia"].stringValue
            let month = item["mes"].stringValue
            let activity = item["atividade"].stringValue
            let description = item["descricao"].stringValue
            let jsonCategory = item["categoria"].dictionaryValue
            let categoryId = jsonCategory["id"]!.intValue
            let categoryName = jsonCategory["nome"]!.stringValue
            
            let dateComplete: String = item["dataCompleta"].stringValue
            let dateDate = (try? Util.convertFromStringToDate(dateString: dateComplete))!
            
            listReturn.append(self.init(id: id, date: date, hour: hour, day: day, month: month,
                                        activity: activity, description: description,
                                        categoryId: categoryId, categoryName: categoryName,
                                        dateDate: dateDate))
        }
        return listReturn
    }
}
