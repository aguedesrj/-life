//
//  LoginRouter.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class LoginRouter {
    
    func present(at navigation: UINavigationController, delegateViewController: MainViewController?) {
        let controller: LoginViewController =
            LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        let presenter = LoginPresenter(view: controller)
        controller.presenter = presenter
        controller.delegate = delegateViewController
        
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        
        navigation.present(controller, animated: true, completion: nil)
    }
    
    func showChangePassword(at viewController: UIViewController, user: User) {
        let controller: ChangePasswordViewController =
            ChangePasswordViewController(nibName: "ChangePasswordViewController",
                                                                      bundle: nil)
        
        let presenter = ChangePasswordPresenter(view: controller, user: user)
        controller.presenter = presenter
        
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        
        viewController.show(controller, sender: nil)
    }
    
    func showForgotPassword(at viewController: UIViewController) {
        let controller: ForgotPasswordViewController =
            ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        
        let presenter = ForgotPasswordPresenter(view: controller)
        controller.presenter = presenter
        
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        
        viewController.show(controller, sender: nil)
    }
    
    func showRegister(at navigation: UINavigationController) {
        let controller: RegisterViewController =
            RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        
        let presenter = RegisterPresenter(view: controller)
        controller.presenter = presenter
        
        navigation.show(controller, sender: nil)
    }
}
