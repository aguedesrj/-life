//
//  ListMessageChat.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ListMessageChat {
    var error: Bool
    var messages: [MessageChat]
    
    init(error: Bool, messages: [MessageChat]) {
        self.error = error
        self.messages = messages
    }
}

extension ListMessageChat {
    static func parse(json: [String: JSON]) -> ListMessageChat {
        let error    = json["error"]!.boolValue
        let messages = MessageChat.parse(json: json["messages"]!.arrayValue)
        
        return ListMessageChat.init(error: error, messages: messages)
    }
}
