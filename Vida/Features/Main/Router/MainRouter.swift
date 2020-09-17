//
//  MainRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class MainRouter {
    
    func show(at navigation: UINavigationController) {
        navigation.setViewControllers([MainViewController(nibName: "MainViewController", bundle: nil)], animated: true)
    }
}
