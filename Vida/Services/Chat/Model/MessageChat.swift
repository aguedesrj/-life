//
//  MessageChat.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MessageChat {
    var createdDate: String
    var message: String
    var fromUserId: Int
    var toUserId: Int
    
    init(createdDate: String, message: String, fromUserId: Int, toUserId: Int) {
        self.createdDate = createdDate
        self.message = message
        self.fromUserId = fromUserId
        self.toUserId = toUserId
    }
}

extension MessageChat {
    static func parse(json: [JSON]) -> [MessageChat] {
        var listReturn: [MessageChat] = []
        for item in json {
            let createdDate = item["createdDate"].stringValue
            let message     = item["message"].stringValue
            let fromUserId  = item["fromUserId"].intValue
            let toUserId    = item["toUserId"].intValue
            
            listReturn.append(self.init(createdDate: createdDate, message: message,
                                        fromUserId: fromUserId, toUserId: toUserId))
        }
        return listReturn
    }
}
