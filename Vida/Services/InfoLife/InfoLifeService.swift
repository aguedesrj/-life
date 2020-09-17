//
//  InfoLifeService.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class InfoLifeService {
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getInfoLifeCategory(success: @escaping ([InfoLifeCategory]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("categoria-publicacao/listar")
        let parameters = ["fromUserId": ""]

        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: parameters, success: { result in

            success(InfoLifeCategory.parseList(json: [JSON(result)]))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getInfoLife(categorys: String, success: @escaping ([InfoLife]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        var serviceUrl = appDelegate.environment.urlMain.appending("publicacao/listar")
        if categorys.count > 0 {
            serviceUrl.append("?categorias=\((categorys))")
        }
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(InfoLife.parse(json: [JSON(result)]))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func registerAccessInfoVida(success: @escaping(Any) -> Void, fail: @escaping(_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("acaoColaborador/infoVida/\(appDelegate.login!.user!.idProfile)")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success("")
        }) { error in
            fail(error)
        }
    }
}
