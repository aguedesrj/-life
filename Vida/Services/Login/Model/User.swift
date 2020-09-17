//
//  User.swift
//  Vida
//
//  Created by Andre Guedes on 15/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    var id: Int
    var code: Int
    var idProfile: Int
    var name: String
    var cpf: String
    var email: String
    var typeProfile: String
    var changeDate: String
    var activeIndicator: Bool
    var changePasswordIndicator: Bool
    
    init(id: Int, code: Int, idProfile: Int, name: String, cpf: String,
         email: String, typeProfile: String, changeDate: String,
         activeIndicator: Bool, changePasswordIndicator: Bool) {
        
        self.id = id
        self.code = code
        self.idProfile = idProfile
        self.name = name
        self.cpf = cpf
        self.email = email
        self.typeProfile = typeProfile
        self.changeDate = changeDate
        self.activeIndicator = activeIndicator
        self.changePasswordIndicator = changePasswordIndicator
    }
}

extension User {
    static func parse(json: [String: JSON]) -> User {
        let id = json["id"]!.intValue
        let code = json["codigo"]!.intValue
        let idProfile = json["idPerfil"]!.intValue
        let name = json["nome"]!.stringValue
        let cpf = json["cpf"]!.stringValue
        let email = json["email"]!.stringValue
        let typeProfile = json["tipoPerfil"]!.stringValue
        let changeDate = json["dataAlteracao"]!.stringValue
        let activeIndicator = json["indicadorAtivo"]!.boolValue
        let changePasswordIndicator = json["indicadorTrocarSenha"]!.boolValue
        
        return self.init(id: id, code: code, idProfile: idProfile, name: name, cpf: cpf, email: email,
                         typeProfile: typeProfile, changeDate: changeDate, activeIndicator: activeIndicator,
                         changePasswordIndicator: changePasswordIndicator)
    }
}
