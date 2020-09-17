//
//  ForgotPasswordPresenter.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordPresenter {
    
    fileprivate var view: ForgotPasswordViewProtocol
    fileprivate var service: LoginService
    
    init(view: ForgotPasswordViewProtocol) {
        self.view = view
        self.service = LoginService()
    }
}

extension ForgotPasswordPresenter {
    
    func forgotPassword(email: String) {
        if (email.isCleanedStringEmpty) {
            self.view.errorValidField(message: "Campo obrigatório")
            return
        }
        
        self.view.showLoadingWithViewController()
        service.forgotPassword(email: email, success: { (result) in
            self.view.hideLoading()
            self.view.returnSuccess(message: result.message)
        }) { (error) in
            self.view.errorValidField(message: error.description)
        }
    }
}
