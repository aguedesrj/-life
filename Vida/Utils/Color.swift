//
//  Color.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

enum Color {
    case primary
    case second
    
    var value: UIColor {
        switch self {
        case .primary: return UIColor(red: 129.0/255.0,
                                      green: 41.0/255.0,
                                      blue: 144.0/255.0,
                                      alpha: 1.0)
            
        case .second: return UIColor(red: 245.0/255.0,
                                      green: 130.0/255.0,
                                      blue: 32.0/255.0,
                                      alpha: 1.0)
        }
    }
}
