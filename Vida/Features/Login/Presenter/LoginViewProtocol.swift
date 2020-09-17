//
//  LoginViewProtocol.swift
//  Vida
//
//  Created by André Lessa Guedes on 08/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: class {
    func hideLoading()
    func showLoadingWithViewController()
    func errorValidFieldCpf(message: String)
    func errorValidFieldPassword(message: String)
    func returnErrorLogin(message: String)
    func returnSuccessLogin(login: Login)
}
