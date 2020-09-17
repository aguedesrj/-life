//
//  RequestError.swift
//  Vida
//
//  Created by Vida on 10/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RequestError {
    var httpStatusCode: Int?
    var code: Int?
    var description: String
    
    init(httpStatusCode: Int, code: Int, description: String) {
        self.httpStatusCode = httpStatusCode
        self.code = code
        self.description = description
    }
    
    init(httpStatusCode: Int, description: String) {
        self.httpStatusCode = httpStatusCode
        self.description = description
    }
    
    init(code: Int, description: String) {
        self.code = code
        self.description = description
    }
    
    init(description: String) {
        self.description = description
    }
}

extension RequestError {
    
    static func parse(json: JSON?) -> RequestError? {
        // verifica se retornou um JSON de erro.
        if (json?.dictionaryValue != nil && json?["code"] != JSON.null && json?["description"] != JSON.null) {
            return self.init(code: (json!["code"].intValue), description: (json!["description"].stringValue))
        }
        
        if (json?.dictionaryValue != nil && json?["codigo"] != JSON.null && json?["mensagem"] != JSON.null) {
            return self.init(code: (json!["codigo"].intValue), description: (json!["mensagem"].stringValue))
        }
        
       return nil
    }
    
//    static func parseError(json: [String: JSON]?) -> RequestError? {
//        if json["retorno"] != JSON.null {
//            let jsonReturn = json["retorno"]!.dictionaryValue
//            if jsonReturn["mensagem"] != JSON.null {
//                let message = jsonReturn["mensagem"]!.stringValue
//
//                return self.init(code: (description: (json!["description"].stringValue)))
//            }
//        }
//        return nil
//    }
}
