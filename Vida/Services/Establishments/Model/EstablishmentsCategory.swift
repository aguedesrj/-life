//
//  EstablishmentsCategory.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EstablishmentsCategory {
    var id: Int
    var name: String
    var icon: String
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

extension EstablishmentsCategory {
    
    static func parseList(json: [JSON]) -> [EstablishmentsCategory] {
        var listReturn: [EstablishmentsCategory] = []
        for item in json[0] {
            let id = item.1["id"].intValue
            let name = item.1["nome"].stringValue
            let icon = item.1["icone"].stringValue
            
            listReturn.append(self.init(id: id, name: name, icon: icon))
        }
        return listReturn
    }
}
