//
//  StateFederationFilterViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct StateFederationFilterViewModel {
    var id: Int
    var code: String
    var name: String
    var selected: Bool
    
    init(id: Int, code: String, name: String, selected: Bool) {
        self.id = id
        self.code = code
        self.name = name
        self.selected = selected
    }
}
