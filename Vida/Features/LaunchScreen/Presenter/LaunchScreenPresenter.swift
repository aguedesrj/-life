//
//  LaunchScreenPresenter.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenPresenter {
    
    fileprivate var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var view: LaunchScreenProtocol
    fileprivate var service: LoginService
    
    init(view: LaunchScreenProtocol) {
        self.view = view
        self.service = LoginService()
    }
}

extension LaunchScreenPresenter {
    
    func login(login: String, password: String) {
        service.login(login: login, password: password, success: { (result) in
            if self.appDelegate.tokenPush.count > 0 {
                self.service.sendTokenPush(pushId: self.appDelegate.tokenPush, userId: result.user!.id, success: { (result) in
                    //
                }, fail: { (erro) in
                    //
                })
            }
            
            self.view.returnSuccessLogin(login: result)
        }) { (error) in
            // não faz nada
        }
    }
}
