//
//  BaseViewController.swift
//  Vida
//
//  Created by Vida on 11/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI

class BaseViewController: UIViewController {

    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var progress: ProgressCustom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pushAutoLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension BaseViewController {
    
    fileprivate func pushAutoLogin() {
        if (self.appDelegate.pushAutoLogin != nil) {
            
            self.appDelegate.pushAutoLogin = nil
            
            // fazer auto-login
            let login: String? = UserDefaults.standard.string(forKey: Constrants.kLogin)
            let password: String? = UserDefaults.standard.string(forKey: Constrants.kPassword)
            
            if (login != nil && password != nil) {
                // auto login
                LoginService().login(login: login!, password: password!, success: { (result) in
                    self.appDelegate.login = result
                }) { (error) in
                    // não faz nada
                }
            }
        }
    }
    
    func showSideMenu() {
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuAnimationDismissDuration = 0.2
        SideMenuManager.default.menuWidth = (UIScreen.main.bounds.width * 80) / 100 // 80 porcento da tela.
    }
    
    func hideSideMenu() {
        SideMenuManager.default.menuAnimationFadeStrength = 0.0
        SideMenuManager.default.menuAnimationDismissDuration = 0.0
        SideMenuManager.default.menuWidth = 0
    }
    
    func showLoadingWithViewController(textProgress: String) {
        if self.progress == nil {
            self.progress = ProgressCustom(viewController: self)
        }
        self.progress.text = textProgress
        self.progress.show()
    }
    
    func showLoadingWithViewController() {
        if self.progress == nil {
            self.progress = ProgressCustom(viewController: self)
        }
        self.progress.show()
    }
    
    func showLoading() {
        if self.progress == nil {
            self.progress = ProgressCustom(navigationController: appDelegate.navController!)
        }
        self.progress.show()
    }
    
    func hideLoading() {
        if self.progress != nil {
            self.progress.hide()
        }
    }
    
    func showAlert(message: String) {
        showAlert(withTitle: "", message: message, buttonTitle: "OK")
    }
    
    func showAlert(withTitle title: String, message: String, buttonTitle: String) {
        hideLoading()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openMenuLeft() {
        self.appDelegate.navController!.present(SideMenuManager.default.menuLeftNavigationController!,
                                                animated: true,
                                                completion: nil)
    }
    
    func sendMail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // alert pra falha no email.
        }
    }
    
    func callPhone(phone: String) {
        Util.dialToPhoneNumber(phone)
    }
}

extension BaseViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
