//
//  CalendarCategory.swift
//  Vida
//
//  Created by Vida on 20/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CalendarCategory {
    var id: Int
    var name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension CalendarCategory {
    
    static func parse(json: [JSON]) -> [CalendarCategory] {
        var listReturn: [CalendarCategory] = []
        for item in json {
            let id   = item["id"].intValue
            let name = item["nome"].stringValue
            
            listReturn.append(self.init(id: id, name: name))
        }
        return listReturn
    }
}
