//
//  ChatUserViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct ChatUserViewModel {
    var createdDate: String
    var message: String
    var isLocal: Bool
    var fromUserId: Int
    var toUserId: Int
    var newSection: Bool
    
    init(createdDate: String, message: String, isLocal: Bool, fromUserId: Int, toUserId: Int) {
        self.createdDate = createdDate
        self.message = message
        self.isLocal = isLocal
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.newSection = false
    }
    
    init(createdDate: String) {
        self.createdDate = createdDate
        self.newSection = true
        self.message = ""
        self.isLocal = false
        self.fromUserId = 0
        self.toUserId = 0
    }
}
