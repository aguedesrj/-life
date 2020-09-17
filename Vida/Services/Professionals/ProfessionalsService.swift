
//
//  ProfessionalsService.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ProfessionalsService {
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getHealthSpecialty(success: @escaping ([HealthSpecialty]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("especialidade-saude/listar")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(HealthSpecialty.parseList(json: [JSON(result)]))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getDomainStates(success: @escaping ([StateFederation]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("dominio/uf/listar")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(StateFederation.parseList(json: (JSON(result).dictionaryValue["retorno"]?.array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getProfessionals(nameProfessional: String?, healthSpecialty: Int?, filterUf: String?, success: @escaping ([Professional]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        var serviceUrl: String = appDelegate.environment.urlMain.appending("profissionalSaude/listar")
        if nameProfessional != nil || healthSpecialty != nil || filterUf != nil {
            serviceUrl.append("?")
            // nome do profissional
//            if nameProfessional != nil {
//                serviceUrl.append("nome=\(nameProfessional?.uppercased() ?? "")")
//            }
            // especialidades
            if healthSpecialty != nil {
                if nameProfessional != nil {
                    serviceUrl.append("&")
                }
                serviceUrl.append("especialidade=\(healthSpecialty ?? 0)")
            }
            // estado
            if filterUf != nil {
                if nameProfessional != nil || healthSpecialty != nil {
                    serviceUrl.append("&")
                }
                serviceUrl.append("uf=\(filterUf ?? "")")
            }
        }
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(Professional.parse(json: (JSON(result).dictionaryValue["retorno"]?.array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func registerAccessProfessional(success: @escaping(Any) -> Void, fail: @escaping(_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("acaoColaborador/profissional/\(appDelegate.login!.user!.idProfile)")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success("")
        }) { error in
            fail(error)
        }
    }
}
