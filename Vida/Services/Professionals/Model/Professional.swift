//
//  Professional.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Professional {
    var id: Int
    var name: String
    var healthSpecialty: HealthSpecialty
    var city: City
    var linkPhoto: String
    var email: String
    var phone: String
    var phoneCell: String
    var address: String
    var district: String
    var healthPlan: String
    
    init(id: Int, name: String, healthSpecialty: HealthSpecialty, city: City,
         linkPhoto: String, email: String, phone: String, phoneCell: String,
         address: String, district: String, healthPlan: String) {
        
        self.id = id
        self.name = name
        self.healthSpecialty = healthSpecialty
        self.city = city
        self.linkPhoto = linkPhoto
        self.email = email
        self.phone = phone
        self.phoneCell = phoneCell
        self.address = address
        self.district = district
        self.healthPlan = healthPlan
    }
}

extension Professional {
    
    static func parse(json: [JSON]) -> [Professional] {
        var listReturn: [Professional] = []
        for item in json {
            let id              = item["id"].intValue
            let name            = item["nome"].stringValue
            let healthSpecialty = HealthSpecialty.parse(json: item["especialidadeSaude"].dictionaryValue)
            let city            = City.parse(json: item["cidade"].dictionaryValue)
            let linkPhoto       = item["linkImagem"].stringValue
            let email           = item["email"].stringValue
            let phone           = item["telefone"].stringValue
            let phoneCell       = item["celular"].stringValue
            let address         = item["endereco"].stringValue
            let district        = item["bairro"].stringValue
            let healthPlan      = item["planoSaude"].stringValue
            
            listReturn.append(self.init(id: id, name: name, healthSpecialty: healthSpecialty,
                                        city: city, linkPhoto: linkPhoto, email: email,
                                        phone: phone, phoneCell: phoneCell, address: address,
                                        district: district, healthPlan: healthPlan))
        }
        return listReturn
    }
}
