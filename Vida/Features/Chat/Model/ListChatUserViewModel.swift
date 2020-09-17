//
//  ListChatUserViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct ListChatUserViewModel {
    var id: Int
    var name: String
    var healthSpecialty: String
    var urlPhoto: String
    var online: Bool
    
    init(id: Int, name: String, healthSpecialty: String, urlPhoto: String,
         online: Bool) {
        self.id = id
        self.name = name
        self.healthSpecialty = healthSpecialty
        self.urlPhoto = urlPhoto
        self.online = online
    }
}
