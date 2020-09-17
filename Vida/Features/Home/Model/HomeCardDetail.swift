//
//  HomeCardDetail.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct HomeCardDetail {
    var nameImage: String
    var nameImageDetail: String
    var title: String
    var description: String
    
    init(nameImage: String, nameImageDetail: String, title: String, description: String) {
        self.nameImage = nameImage
        self.nameImageDetail = nameImageDetail
        self.title = title
        self.description = description
    }
}
