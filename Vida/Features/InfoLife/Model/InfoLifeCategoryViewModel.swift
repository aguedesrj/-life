//
//  InfoLifeCategoryViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct InfoLifeCategoryViewModel {
    var id: Int
    var name: String
    var url: String
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
