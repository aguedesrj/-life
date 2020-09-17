//
//  ChatViewProtocol.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol ChatViewProtocol: class {
    func returnErrorGetMessages(message: String)
    func returnSuccessGetMessages(chatUserViewModel: ListChatUserViewModel,
                                  messages: [ChatUserViewModel])
}
