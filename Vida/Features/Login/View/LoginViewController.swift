//
//  LoginViewController.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol LoginViewDelegate {
    func goTabBarSelected()
}

class LoginViewController: BaseViewController {

    @IBOutlet weak var textFieldCpf: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeightImageBg: NSLayoutConstraint!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var constraintWidthButtonLogin: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var constraintTopTextFieldCpf: NSLayoutConstraint!
    @IBOutlet weak var constraintTopTextFieldPassword: NSLayoutConstraint!
    
    var presenter: LoginPresenter!
    var delegate: LoginViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        textFieldCpf.setMaterialLayout()
        textFieldPassword.setMaterialLayout()
        
        if #available(iOS 12, *) {
            textFieldCpf.textContentType = .oneTimeCode
            textFieldPassword.textContentType = .oneTimeCode
        } else {
            textFieldCpf.textContentType = .init(rawValue: "")
            textFieldPassword.textContentType = .init(rawValue: "")
        }
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.adjustmentLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func pressForgotPassword(_ sender: Any) {
        LoginRouter().showForgotPassword(at: self)
    }
    
    @IBAction func pressRegister(_ sender: Any) {
//        LoginRouter().showRegister(at: self.navigationController!)
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        self.presenter.login(login: textFieldCpf.text!, password: textFieldPassword.text!)
    }
}

extension LoginViewController {
    
    fileprivate func adjustmentLayout() {
        if Device.isIPhone5() {
            constraintHeightImageBg.constant = 120.0
            labelDescription.font = labelDescription.font.withSize(12)
            constraintWidthButtonLogin.constant = 80.0
            buttonForgotPassword.titleLabel?.font = labelDescription.font.withSize(11)
            constraintTopLabelTitle.constant = 28.0
            constraintTopTextFieldCpf.constant = 35.0
            constraintTopTextFieldPassword.constant = 35.0
        }
    }

    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        if Device.isIPhone5() {
            contentInset.bottom = keyboardFrame.size.height + 30.0
        } else {
            contentInset.bottom = keyboardFrame.size.height
        }
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc fileprivate func changePasswordNotification(notification: Notification) -> Void {
        textFieldPassword.text = notification.userInfo!["newPassword"] as? String
        self.pressLogin(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldCpf {
            textFieldCpf.errorMessage = ""
        } else if textField == textFieldPassword {
            textFieldPassword.errorMessage = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldCpf {
            textFieldPassword.becomeFirstResponder()
        } else if textField.returnKeyType == UIReturnKeyType.go {
            textField.resignFirstResponder()
            pressLogin(self)
        }
        return true
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func errorValidFieldCpf(message: String) {
        textFieldCpf.errorColor = UIColor.red
        textFieldCpf.errorMessage = message
    }
    
    func errorValidFieldPassword(message: String) {
        textFieldPassword.errorColor = UIColor.red
        textFieldPassword.errorMessage = message
    }
    
    func returnErrorLogin(message: String) {
        self.showAlert(message: message)
    }
    
    func returnSuccessLogin(login: Login) {
        // verifica se deve trocar senha
        if ((login.user?.changePasswordIndicator)!) {
            // notificação
            NotificationCenter.default.addObserver(self, selector: #selector(changePasswordNotification(notification:)),
                                                   name: Notification.Name(rawValue: "ChangePasswordNotification"), object: nil)
            
            LoginRouter().showChangePassword(at: self, user: login.user!)
            return
        }
        
        UserDefaults.standard.set(textFieldCpf.text, forKey: Constrants.kLogin)
        UserDefaults.standard.set(textFieldPassword.text, forKey: Constrants.kPassword)
        self.appDelegate.login = login
        
        if self.delegate != nil {
            self.delegate!.goTabBarSelected()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
