//
//  StyleGradientCircularProgress.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import GradientCircularProgress

public struct StyleGradientCircularProgress : StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 36
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 3.0
    public var startArcColor: UIColor = UIColor(white: 80.0 / 255.0, alpha: 1.0)
    public var endArcColor = UIColor(red: 246.0 / 255.0, green: 165.0 / 255.0, blue: 96.0 / 255.0, alpha: 0.0)
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 3.0
    public var baseArcColor: UIColor? = UIColor(red:0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "OpenSans-Bold", size: 12.0)
    public var ratioLabelFontColor: UIColor? = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
    // Message
    public var messageLabelFont: UIFont? = UIFont(name: "OpenSans-Bold", size: 12.0)
    public var messageLabelFontColor: UIColor? = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
    // Background
    public var backgroundStyle: BackgroundStyles = .transparent
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0
    
    public init() {}
}
