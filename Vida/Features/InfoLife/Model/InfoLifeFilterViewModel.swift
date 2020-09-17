//
//  InfoLifeFilterViewModel.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

struct InforLifeFilterViewModel {
    var id: Int
    var name: String
    var url: String
    var selected: Bool
    var image: UIImage?
    
    init(id: Int, name: String, url: String, selected: Bool) {
        self.id = id
        self.name = name
        self.url = url
        self.selected = selected
    }
}
