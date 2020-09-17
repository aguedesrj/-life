//
//  EstablishmentsService.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class EstablishmentsService {
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getEstablishmentsCategory(success: @escaping ([EstablishmentsCategory]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("categoria-parceiro/listar")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(EstablishmentsCategory.parseList(json: [JSON(result)]))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getEstablishmentsUfs(success: @escaping ([StateFederation]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("parceiro/uf/listar")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(StateFederation.parseList(json: (JSON(result).dictionaryValue["retorno"]?.array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getEstablishments(filterEstablishmentsCategory: String, filterEstablishmentsUf: String, success: @escaping ([Establishments]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        var serviceUrl: String = appDelegate.environment.urlMain.appending("parceiro/listar")
        
        if filterEstablishmentsCategory.count > 0 || filterEstablishmentsUf.count > 0 {
            serviceUrl.append("?")
            if filterEstablishmentsCategory.count > 0 {
                serviceUrl.append("categoria=\(filterEstablishmentsCategory)")
            }
            if filterEstablishmentsUf.count > 0 {
                if filterEstablishmentsCategory.count > 0 {
                    serviceUrl.append("&")
                }
                serviceUrl.append("uf=\(filterEstablishmentsUf)")
            }
        }
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(Establishments.listParse(json: (JSON(result).dictionaryValue["retorno"]?.array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getEstablishmentsByQrCode(qrCode: String, success: @escaping (Establishments) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl: String = appDelegate.environment.urlMain.appending("parceiro/obterPorQrCode")
        
        let header = ["colaborador": String((appDelegate.login?.user?.idProfile)!),
                      "qrCode": qrCode]
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            
            let jsonResult = JSON(result).dictionaryValue
            success(Establishments.parse(json: jsonResult["retorno"]!.dictionaryValue))
        }) { error in
            fail(error)
        }
    }
}

