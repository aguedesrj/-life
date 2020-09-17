//
//  City.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct City {
    var id: Int
    var name: String
    var stateFederation: StateFederation
    
    init(id: Int, name: String, stateFederation: StateFederation) {
        self.id = id
        self.name = name
        self.stateFederation = stateFederation
    }
}

extension City {
    static func parse(json: [String: JSON]) -> City {
        let id              = json["id"]!.intValue
        let name            = json["nome"]!.stringValue
        let stateFederation = StateFederation.parse(json: json["estadoFederacao"]!.dictionaryValue)
        
        return self.init(id: id, name: name, stateFederation: stateFederation)
    }
}
