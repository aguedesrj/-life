//
//  LoginService.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class LoginService {
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func login(login: String, password: String, success: @escaping (Login) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        let serviceUrl = appDelegate.environment.urlMain.appending("seguranca/login")
        
        let header = ["usuario": login, "senha": password]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            
            let login: Login = Login.parse(json: JSON(result).dictionaryValue)
            if (login.user != nil) {
                success(Login.parse(json: JSON(result).dictionaryValue))
                return
            }
            let errorFail: RequestError = RequestError(code: 0, description: login.message)
            fail(errorFail)
        }) { error in
            var errorFail: RequestError = error
            if (errorFail.httpStatusCode == 404) {
                errorFail.description = "Usuário informado não existe!"
            } else if (errorFail.httpStatusCode == 403) {
                errorFail.description = "Senha informada incorreta!"
            } else {
                errorFail.description = Constrants.messageSystemUnavailable
            }
            fail(errorFail)
        }
    }
    
    func logoutChat(success: @escaping (String) -> Void, fail: @escaping (_ error: String) -> Void) {
        let serviceUrl = appDelegate.environment.urlChat.appending("/logout")
        
        let parameters = ["userid": String((appDelegate.login?.user?.id)!),
                          "pushid": appDelegate.tokenPush]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: nil, parameters: parameters, success: { result in
            // não faz nada
            success("")
        }) { error in
            // não faz nada
            print(error)
            fail("")
        }
    }
    
    func validToken(token: String, success: @escaping (Login) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        let serviceUrl = appDelegate.environment.urlMain.appending("seguranca/validarToken")
        
        let header = ["token": token]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            success(Login.parse(json: JSON(result).dictionaryValue))
        }) { error in
            fail(error)
        }
    }
    
    func forgotPassword(email: String, success: @escaping (Login) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        let serviceUrl = appDelegate.environment.urlMain.appending("seguranca/recuperarSenha")
        
        let header = ["usuario": email]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            
            success(Login.parse(json: JSON(result).dictionaryValue))
        }) { error in
            fail(error)
        }
    }
    
    func changePassword(idUser: Int, newPassword: String, success: @escaping (Login) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        let serviceUrl = appDelegate.environment.urlMain.appending("seguranca/alterarSenha")
        
        let header = ["idUsuario": String(idUser),
                      "senha": newPassword]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            
            success(Login.parse(json: JSON(result).dictionaryValue))
        }) { error in
            fail(error)
        }
    }
    
    func sendTokenPush(pushId: String, userId: Int, success: @escaping (String) -> Void, fail: @escaping (_ error: String) -> Void) {
        let serviceUrl = appDelegate.environment.urlChat.appending("/addPushId")
        
        let parameters = ["pushId": pushId, "userId": String(userId)]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: nil, parameters: parameters, success: { result in
            // não faz nada
            success("")
        }) { error in
            // não faz nada
            fail("")
        }
    }
}
