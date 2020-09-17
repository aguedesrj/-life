//
//  ForgotPasswordViewProtocol.swift
//  Vida
//
//  Created by André Lessa Guedes on 08/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol ForgotPasswordViewProtocol: class {
    func hideLoading()
    func showLoadingWithViewController()
    func returnSuccess(message: String)
    func errorValidField(message: String)
}
