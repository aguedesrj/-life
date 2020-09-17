//
//  ForgotPasswordViewController.swift
//  Vida
//
//  Created by Vida on 06/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonBack: UIButton!
    
    var presenter: ForgotPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.imageView?.tintColor = Color.primary.value
        
        self.hideKeyboardWhenTappedAround()

        textFieldEmail.setMaterialLayout()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressButtonSend(_ sender: Any) {
        self.presenter.forgotPassword(email: textFieldEmail.text!)
    }
}

extension ForgotPasswordViewController {
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == textFieldEmail {
            textFieldEmail.errorMessage = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.go {
            textField.resignFirstResponder()
            pressButtonSend(self)
        }
        return true
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewProtocol {
    
    func returnSuccess(message: String) {
        let alert = UIAlertController(title: "Sucesso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { result in
            self.pressButtonBack(self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorValidField(message: String) {
        self.showAlert(message: message)
    }
}
