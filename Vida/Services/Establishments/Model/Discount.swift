//
//  Discount.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Discount {
    var id: Int
    var name: String
    var status: String
    var percentage: Int
    var percentageAll: Int
    
    init(id: Int, name: String, status: String, percentage: Int, percentageAll: Int) {
        self.id = id
        self.name = name
        self.status = status
        self.percentage = percentage
        self.percentageAll = percentageAll
    }
}

extension Discount {
    static func parse(json: [String: JSON]) -> Discount {
        let id = json["id"]!.intValue
        let name   = json["nome"]!.stringValue
        let status = json["status"]!.stringValue
        let percentage = json["percentual"]!.intValue
        let percentageAll = json["percentualInteiro"]!.intValue
        
        return self.init(id: id, name: name, status: status, percentage: percentage,
                         percentageAll: percentageAll)
    }
}
