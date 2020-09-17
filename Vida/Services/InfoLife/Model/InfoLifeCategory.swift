//
//  InfoLifeCategory.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InfoLifeCategory {
    var id: Int
    var name: String
    var icon: String
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

extension InfoLifeCategory {
    static func parse(json: [String: JSON]) -> InfoLifeCategory {
        let id = json["id"]!.intValue
        let name = json["nome"]!.stringValue
        let icon = json["icone"]!.stringValue
        
        return self.init(id: id, name: name, icon: icon)
    }
    
    static func parseList(json: [JSON]) -> [InfoLifeCategory] {
        var listReturn: [InfoLifeCategory] = []
        for item in json[0] {
            let id = item.1["id"].intValue
            let name = item.1["nome"].stringValue
            let icon = item.1["icone"].stringValue
            
            listReturn.append(self.init(id: id, name: name, icon: icon))
        }
        return listReturn
    }
}
