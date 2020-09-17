//
//  MainViewController.swift
//  Vida
//
//  Created by André Lessa Guedes on 19/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var presenter: MainPresenter!
    
    fileprivate var viewControllerInAction: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .white
        tabBar.isTranslucent = true
        
        tabBar.shadowImage = UIImage()
        tabBar.barStyle = .black
        
        self.viewControllerInAction = self.viewControllers![0] // default
        
        // notification usada para quando o usuário desistir de logar voltar a viewcontroller anterior
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "BackTabBarLogin"),
                                               object: nil,
                                               queue: nil,
                                               using: backTabBar(notification:))
        
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension MainViewController {
    
    func backTabBar(notification:Notification) {
        self.selectedViewController = viewControllerInAction
    }
}

extension MainViewController: MainViewProtocol {
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (self.appDelegate.login == nil && viewController.isKind(of: ProfessionalsViewController.self)) {
            LoginRouter().present(at: self.appDelegate.navController!)
        } else {
            self.viewControllerInAction = viewController
        }
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 75
        return sizeThatFits
    }
}
