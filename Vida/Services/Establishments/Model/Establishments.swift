//
//  Establishments.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Establishments {
    var id: Int
    var category: Category
    var user: User
    var city: City
    var code: String
    var name: String
    var typePerson: String
    var cpf: String
    var cnpj: String
    var address: String
    var addressComplement: String
    var district: String
    var cep: String
    var phone: String
    var phoneCell: String
    var email: String
    var webSite: String
    var image: UIImage?
    var urlImage: String
    var activeIndicator: Bool
    var stateFederation: StateFederation
    var discount: Discount
    var text: String
    var textSummary: String
    
    init(id: Int, category: Category, user: User, city: City, code: String, name: String,
         typePerson: String, cpf: String, cnpj: String, address: String, addressComplement: String,
         district: String, cep: String, phone: String, email: String, webSite: String, urlImage: String,
         activeIndicator: Bool, stateFederation: StateFederation, discount: Discount, phoneCell: String, text: String, textSummary: String) {
        
        self.id = id
        self.category = category
        self.user = user
        self.city = city
        self.code = code
        self.name = name
        self.typePerson = typePerson
        self.cpf = cpf
        self.cnpj = cnpj
        self.address = address
        self.addressComplement = addressComplement
        self.district = district
        self.cep = cep
        self.phone = phone
        self.phoneCell = phoneCell
        self.email = email
        self.webSite = webSite
        self.urlImage = urlImage
        self.activeIndicator = activeIndicator
        self.stateFederation = stateFederation
        self.discount = discount
        self.text = text
        self.textSummary = textSummary
    }
}

extension Establishments {
    
    static func parse(json: [String: JSON]) -> Establishments {
        
        let id                = json["id"]!.intValue
        let category          = Category.parse(json: json["categoria"]!.dictionaryValue)
        let user              = User.parse(json: json["usuario"]!.dictionaryValue)
        let city              = City.parse(json: json["cidade"]!.dictionaryValue)
        let stateFederation   = StateFederation.parse(json: json["estadoFederacao"]!.dictionaryValue)
        let discount          = Discount.parse(json: json["desconto"]!.dictionaryValue)
        let code              = json["codigo"]!.stringValue
        let name              = json["nome"]!.stringValue
        let typePerson        = json["tipoPessoa"]!.stringValue
        let cpf               = json["cpf"]!.stringValue
        let cnpj              = json["cnpj"]!.stringValue
        let address           = json["endereco"]!.stringValue
        let addressComplement = json["enderecoComplemento"]!.stringValue
        let district          = json["bairro"]!.stringValue
        let cep               = json["cep"]!.stringValue
        let phone             = json["telefone"]!.stringValue
        let phoneCell         = json["celular"]!.stringValue
        let email             = json["email"]!.stringValue
        let webSite           = json["site"]!.stringValue
        let urlImage          = json["linkImagem"]?.stringValue
        let activeIndicator   = json["indicadorAtivo"]!.boolValue
        let text              = json["texto"]!.stringValue
        let textSummary       = json["textoResumido"]!.stringValue
        
        return self.init(id: id, category: category, user: user, city: city, code: code,
                         name: name, typePerson: typePerson, cpf: cpf, cnpj: cnpj, address: address,
                         addressComplement: addressComplement, district: district, cep: cep, phone: phone,
                         email: email, webSite: webSite, urlImage: urlImage ?? "", activeIndicator: activeIndicator,
                         stateFederation: stateFederation, discount: discount, phoneCell: phoneCell, text: text, textSummary: textSummary)
    }
    
    static func listParse(json: [JSON]) -> [Establishments] {
        var listReturn: [Establishments] = []
        for item in json {
            listReturn.append(self.parse(json: item.dictionaryValue))
        }
        
        return listReturn
    }
}
