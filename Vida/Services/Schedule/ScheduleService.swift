//
//  ScheduleService.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class ScheduleService {
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getSchedules(success: @escaping ([Schedule]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let userId: Int = (appDelegate.login?.user!.idProfile)!
        let serviceUrl = appDelegate.environment.urlMain.appending("agenda/listar/\(userId)")

        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in

            success(Schedule.parse(json: (JSON(result).array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func getCalendarCategory(success: @escaping ([CalendarCategory]) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("categoria-agenda/listar")
        
        Request.sharedInstance.request(method: .get, url: serviceUrl, urlParameters: nil, headers: nil, parameters: nil, success: { result in
            
            success(CalendarCategory.parse(json: (JSON(result).array)!))
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func insert(idAgenda: Int?, activity: String, category: Int, description: String, date: String, hour: String, success: @escaping (String) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("agenda/salvar")
        
        let header = ["Content-Type": "application/json"]
        
        var categoryDictionary = Dictionary<String, Any>()
        categoryDictionary["id"] = String(category) as AnyObject
        var profileDictionary = Dictionary<String, Any>()
        profileDictionary["id"] = String((appDelegate.login?.user?.idProfile)!) as AnyObject
        
        var dataJson = Dictionary<String, AnyObject>()
        if (idAgenda != nil) {
            dataJson["id"] = idAgenda as AnyObject
        }
        dataJson["categoria"] = categoryDictionary as AnyObject
        dataJson["atividade"] = activity.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dataJson["descricao"] = description.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dataJson["data"] = date as AnyObject
        dataJson["hora"] = hour as AnyObject
        dataJson["colaborador"] = profileDictionary as AnyObject
        
        print("************ ENVIANDO DATAJSON: \(dataJson) ************")
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: dataJson, success: { result in
            
            let json: JSON = JSON(result)
            success(json["mensagem"].stringValue)
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
    
    func remove(idAgenda: Int, success: @escaping (String) -> Void, fail: @escaping (_ error: RequestError) -> Void) {
        
        let serviceUrl = appDelegate.environment.urlMain.appending("agenda/excluir")
        
        let header = ["idAgenda": String(idAgenda),
                      "idColaborador": String((appDelegate.login?.user?.idProfile)!)]
        
        Request.sharedInstance.request(method: .post, url: serviceUrl, urlParameters: nil, headers: header, parameters: nil, success: { result in
            
            let json: JSON = JSON(result)
            success(json["mensagem"].stringValue)
        }) { error in
            var errorFail: RequestError = error
            errorFail.description = Constrants.messageSystemUnavailable
            fail(errorFail)
        }
    }
}
