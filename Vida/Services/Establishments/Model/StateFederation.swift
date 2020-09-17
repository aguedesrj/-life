//
//  StateFederation.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StateFederation {
    var id: Int
    var code: String
    var name: String
    
    init(id: Int, code: String, name: String) {
        self.id = id
        self.code = code
        self.name = name
    }
}

extension StateFederation {
    
    static func parse(json: [String: JSON]) -> StateFederation {
        let id   = json["id"]!.intValue
        let code = json["codigo"]!.stringValue
        let name = json["nome"]!.stringValue
        
        return self.init(id: id, code: code, name: name)
    }
    
    static func parseList(json: [JSON]) -> [StateFederation] {
        var listReturn: [StateFederation] = []
        for item in json {
            let id = item["id"].intValue
            let code = item["codigo"].stringValue
            let name = item["nome"].stringValue
            
            listReturn.append(self.init(id: id, code: code, name: name))
        }
        return listReturn
    }
}
