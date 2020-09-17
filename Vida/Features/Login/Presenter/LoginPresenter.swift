//
//  LoginPresenter.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class LoginPresenter {
    
    fileprivate var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var view: LoginViewProtocol
    fileprivate var service: LoginService
    
    init(view: LoginViewProtocol) {
        self.view = view
        self.service = LoginService()
    }
}

extension LoginPresenter {
    
    func login(login: String, password: String) {
        var validFields: Bool = true
        
        if (login.isCleanedStringEmpty) {
            self.view.errorValidFieldCpf(message: "Campo obrigatório")
            validFields = false
        }
        
        if (password.isCleanedStringEmpty) {
            self.view.errorValidFieldPassword(message: "Campo obrigatório")
            validFields = false
        }
        
        if validFields {
            self.view.showLoadingWithViewController()
            service.login(login: login, password: password, success: { (result) in
                // verifica se é colaborador.
                if result.user?.typeProfile != "COLABORADOR" {
                    self.view.returnErrorLogin(message: "Acesso apenas para Colaborador.")
                    return
                }
                
                if self.appDelegate.tokenPush.count > 0 {
                    self.service.sendTokenPush(pushId: self.appDelegate.tokenPush, userId: result.user!.id, success: { (result) in
                        //
                    }, fail: { (erro) in
                        //
                    })
                }
                
                self.view.hideLoading()
                self.view.returnSuccessLogin(login: result)
            }) { (error) in
                self.view.returnErrorLogin(message: error.description)
            }
        }
    }
}
