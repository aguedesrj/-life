//
//  MainPresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

class MainPresenter {
    
    fileprivate var service: LoginService
    
    init() {
        self.service = LoginService()
    }
}

extension MainPresenter {

    func logouChat() {
        service.logoutChat(success: {_ in
            // não faz nada
        }) { (error) in
            // não faz nada
        }
    }
}
