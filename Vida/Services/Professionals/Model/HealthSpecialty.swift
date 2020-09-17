//
//  HealthSpecialty.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HealthSpecialty {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension HealthSpecialty {
    
    static func parseList(json: [JSON]) -> [HealthSpecialty] {
        var listReturn: [HealthSpecialty] = []
        for item in json[0] {
            let id = item.1["id"].intValue
            let name = item.1["nome"].stringValue
            
            listReturn.append(self.init(id: id, name: name))
        }
        return listReturn
    }
    
    static func parse(json: [String: JSON]) -> HealthSpecialty {
        return HealthSpecialty.init(id: json["id"]!.intValue, name: json["nome"]!.stringValue)
    }
}
