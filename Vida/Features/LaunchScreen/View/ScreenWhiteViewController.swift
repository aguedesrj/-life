//
//  ScreenWhiteViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ScreenWhiteViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController: UIViewController!
        let tutorial: String? = UserDefaults.standard.string(forKey: Constrants.kTutorial)
        
        if (tutorial == nil) {
            viewController = TutorialViewController(nibName: "TutorialViewController", bundle: nil)
        } else {
            viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        }
        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        self.appDelegate.navController = UINavigationController(rootViewController: viewController)
        self.appDelegate.window?.rootViewController = self.appDelegate.navController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.appDelegate.window?.makeKeyAndVisible()
    }
}
