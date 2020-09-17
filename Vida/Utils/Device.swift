//
//  Device.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

final class Device {
    
    class func family() -> UIUserInterfaceIdiom {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return .pad
        case .phone, .unspecified: return .phone
        default: return .phone
        }
    }
    
    class func screenSize() -> CGSize {
        let size = UIScreen.main.bounds.size
        if family() == .pad {
            return CGSize(width: max(size.width, size.height), height: min(size.width, size.height))
        } else {
            let teste = UIScreen.main.nativeBounds.size
            return teste
        }
    }
    
    class func isIPhone4() -> Bool {
        return screenSize().height == 960.0
    }
    
    class func isIPhone5() -> Bool {
        return screenSize().height == 1136.0
    }
    
    class func isIPhone6() -> Bool {
        return screenSize().height == 1334.0
    }
    
    class func isIPhoneXR() -> Bool {
        return screenSize().height == 1792.0
    }
    
    class func isIPhonePlus() -> Bool {
        return screenSize().height == 2208.0 || screenSize().height == 1920.0
    }
    
    class func isIPhoneXAndXS() -> Bool {
        return screenSize().height == 2436.0
    }
    
    class func isIPhoneXSMax() -> Bool {
        return screenSize().height == 2688.0
    }
}
