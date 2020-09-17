//
//  HomeRouter.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class HomeRouter {
    
    func show(at navigation: UINavigationController) {
        let mainController = UIStoryboard(name: "MainViewController", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        
        let presenter = MainPresenter(view: mainController)
        mainController.presenter = presenter
        
        navigation.setViewControllers([mainController], animated: true)
    }
    
    func showDetail(at navigation: UINavigationController, indexSelected: Int, homeCard: HomeCard) {
        
        let controller: MainDetailViewController =
            MainDetailViewController(nibName: "MainDetailViewController", bundle: nil)

        controller.indexSelected = indexSelected
        controller.homeCard = homeCard
        navigation.show(controller, sender: nil)
    }
}
