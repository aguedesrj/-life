//
//  Category.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {
    var id: Int
    var code: String
    var name: String
    
    init(id: Int, code: String, name: String) {
        self.id = id
        self.code = code
        self.name = name
    }
}

extension Category {
    
    static func parse(json: [String: JSON]) -> Category {
        let id   = json["id"]!.intValue
        let code = json["codigo"]!.stringValue
        let name = json["nome"]!.stringValue
        
        return self.init(id: id, code: code, name: name)
    }
}
