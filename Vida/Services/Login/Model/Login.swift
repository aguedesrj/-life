//
//  Login.swift
//  Vida
//
//  Created by Andre Guedes on 15/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Login {
    
    var token: String
    var user: User?
    var message: String
    init(token: String, user: User?, message: String) {
        self.token = token
        self.user = user
        self.message = message
    }
}

extension Login {
    static func parse(json: [String: JSON]) -> Login {
        let jsonLogin = json["retorno"]!.dictionaryValue
        
        let token = jsonLogin["token"]!.stringValue
        let message = jsonLogin["mensagem"]!.stringValue
        var user: User? = nil
        if message == "" {
            user = User.parse(json: jsonLogin["usuario"]!.dictionaryValue)
        }
        return self.init(token: token, user: user, message: message)
    }
}
