//
//  ChatService.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class ChatService {
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func getMessages(fromUserId: Int, toUserId: Int, success: @escaping (ListMessageChat) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        let serviceUrl = appDelegate.environment.urlChat.appending("/getMessages")
        
        let headers = ["Content-Type" : "application/json"]
        let parameters = ["fromUserId": fromUserId, "toUserId": toUserId]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: headers, parameters: parameters, success: { result in
            
            success(ListMessageChat.parse(json: JSON(result).dictionaryValue))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func registerAccessProfessionalChat(success: @escaping(Any) -> Void, fail: @escaping(_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("acaoColaborador/profissionalChat/\(appDelegate.login!.user!.idProfile)")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success("")
        }) { error in
            fail(error)
        }
    }
}
