//
//  InfoLife.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InfoLife {
    var id: Int
    var category: InfoLifeCategory
    var title: String
    var text: String
    var publicationDate: String
    var publicationDateFormat: String
    var urlImageDetach: String
    var type: String
    var shortText: String
    var typeImage: Bool
    var typeMove: Bool
    var image: UIImage?
    
    init(id: Int, category: InfoLifeCategory, title: String, text: String,
         publicationDate: String, publicationDateFormat: String, urlImageDetach: String,
         type: String, shortText: String, typeImage: Bool, typeMove: Bool) {
        
        self.id = id
        self.category = category
        self.title = title
        self.text = text
        self.publicationDate = publicationDate
        self.publicationDateFormat = publicationDateFormat
        self.urlImageDetach = urlImageDetach
        self.type = type
        self.shortText = shortText
        self.typeImage = typeImage
        self.typeMove = typeMove
    }
}

extension InfoLife {
    
    static func parse(json: [JSON]) -> [InfoLife] {
        var listReturn: [InfoLife] = []
        for item in json[0] {
            let id                    = item.1["id"].intValue
            let title                 = item.1["titulo"].stringValue
            let text                  = item.1["texto"].stringValue
            let publicationDate       = item.1["dataPublicacao"].stringValue
            let publicationDateFormat = item.1["dataPublicacaoFormatada"].stringValue
            let urlImageDetach        = item.1["urlImagemDestaque"].stringValue
            let type                  = item.1["tipo"].stringValue
            let shortText             = item.1["textoResumido"].stringValue
            let typeImage             = item.1["tipoImagem"].boolValue
            let typeMove              = item.1["tipoVideo"].boolValue
            let category              = InfoLifeCategory.init(id: item.1["categoria"]["id"].intValue,
                                                        name: item.1["categoria"]["nome"].stringValue,
                                                        icon: item.1["categoria"]["icone"].stringValue)
            
            listReturn.append(self.init(id: id, category: category, title: title, text: text,
                                        publicationDate: publicationDate, publicationDateFormat: publicationDateFormat,
                                        urlImageDetach: urlImageDetach, type: type, shortText: shortText,
                                        typeImage: typeImage, typeMove: typeMove))
        }
        return listReturn
    }
}
