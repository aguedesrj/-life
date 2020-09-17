//
//  InfoLifeRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class InfoLifeRouter {
    
    func showDetail(at navigation: UINavigationController, infoLife: InfoLife) {
        
        let controller: InfoLifeDetailViewController =
            InfoLifeDetailViewController(nibName: "InfoLifeDetailViewController", bundle: nil)
        
        controller.infoLife = infoLife
        navigation.show(controller, sender: nil)
    }
    
    func showFilter(at navigation: UINavigationController, presenter: InfoLifePresenter,
                    delegate: InfoLifeViewController) {
        
        let controller: InfoLifeFilterViewController =
            InfoLifeFilterViewController(nibName: "InfoLifeFilterViewController", bundle: nil)
        controller.presenter = presenter
        controller.delegate = delegate
        
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
}
