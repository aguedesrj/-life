//
//  ChangePasswordPresenter.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordPresenter {
    
    fileprivate var view: ChangePasswordViewProtocol
    fileprivate var service: LoginService
    fileprivate var user: User!
    
    init(view: ChangePasswordViewProtocol, user: User) {
        self.view = view
        self.user = user
        self.service = LoginService()
    }
}

extension ChangePasswordPresenter {
    
    func changePassword(newPassword: String) {
        if (newPassword.isCleanedStringEmpty) {
            self.view.errorValidField(message: "Campo obrigatório")
            return
        }
        
        self.view.showLoadingWithViewController()
        service.changePassword(idUser: self.user.id, newPassword: newPassword, success: { (result) in
            self.view.hideLoading()
            self.view.returnSuccess(message: result.message)
        }) { (error) in
            self.view.errorValidField(message: error.description)
        }
    }
}
