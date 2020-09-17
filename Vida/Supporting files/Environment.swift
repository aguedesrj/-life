//
//  Environment.swift
//  Vida
//
//  Created by Vida on 10/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

enum Environment {
    
    case release
    case staging
    case debug
    
    var urlMain: String {
        switch self {
        case .release: return ""
        case .staging: return ""
        case .debug:   return ""
        }
    }
    
    var urlMainWeb: String {
        switch self {
        case .release: return ""
        case .staging: return ""
        case .debug:   return ""
        }
    }
    
    var urlChat: String {
        switch self {
        case .release: return ""
        case .staging: return ""
        case .debug:   return ""
        }
    }
    
    var googleMapsPlaceId: String {
        switch self {
        case .release: return ""
        case .staging: return ""
        case .debug:   return ""
        }
    }
    
    var googleTrackingId: String {
        switch self {
        case .release: return ""
        case .staging: return ""
        case .debug:   return ""
        }
    }
}
