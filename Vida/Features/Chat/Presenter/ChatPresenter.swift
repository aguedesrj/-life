//
//  ChatPresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

class ChatPresenter {
    
    fileprivate var view: ChatViewProtocol!
    fileprivate var service: ChatService!
    
    init(view: ChatViewProtocol) {
        self.view = view
        self.service = ChatService()
    }
    
    init() {
        self.service = ChatService()
    }
}

extension ChatPresenter {
    
    func getMessages(fromUserId: Int, toUserId: Int, chatUserViewModel: ListChatUserViewModel) {
        self.service.getMessages(fromUserId: fromUserId, toUserId: toUserId, success: { (result) in
            if !result.error && result.messages.count > 0 {
                var list: [ChatUserViewModel] = []
                for messageChat: MessageChat in result.messages {
                    if fromUserId == messageChat.fromUserId {
                        list.append(ChatUserViewModel.init(createdDate: messageChat.createdDate, message: messageChat.message, isLocal: true, fromUserId: messageChat.fromUserId, toUserId: messageChat.toUserId))
                    } else {
                        list.append(ChatUserViewModel.init(createdDate: messageChat.createdDate, message: messageChat.message, isLocal: false, fromUserId: messageChat.fromUserId, toUserId: messageChat.toUserId))
                    }
                }
                self.view.returnSuccessGetMessages(chatUserViewModel: chatUserViewModel, messages: list)
                return
            }
            self.view.returnSuccessGetMessages(chatUserViewModel: chatUserViewModel, messages: [])
        }) { (error) in
            self.view.returnErrorGetMessages(message: error.description)
        }
    }
    
    func registerAccessProfessionalChat() {
        self.service.registerAccessProfessionalChat(success: { (result) in
            //
        }) { (error) in
            //
        }
    }
}
