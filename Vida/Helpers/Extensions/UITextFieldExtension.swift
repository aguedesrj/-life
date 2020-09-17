//
//  UITextFieldExtension.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

extension UITextField {
    
    func setMaterialLayout() {
        if ((self as? SkyFloatingLabelTextField) != nil) {
            //            (self as! SkyFloatingLabelTextField).titleFont = UIFont(name: (self.font?.fontName)!, size: 12)!
            (self as! SkyFloatingLabelTextField).titleFormatter = { $0 }
        }
    }
}
