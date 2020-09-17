//
//  EstablishmentsRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class EstablishmentsRouter {
    
    func show(at navigation: UINavigationController) {
        
        let controller: EstablishmentsViewController =
            EstablishmentsViewController(nibName: "EstablishmentsViewController", bundle: nil)
        
        navigation.show(controller, sender: nil)
    }
    
    func showDetail(at navigation: UINavigationController, establishments: Establishments) {
        
        let controller: EstablishmentsDetailViewController =
            EstablishmentsDetailViewController(nibName: "EstablishmentsDetailViewController", bundle: nil)
        
        controller.establishments = establishments
        navigation.show(controller, sender: nil)
    }
    
    func showFilter(at navigation: UINavigationController, presenter: EstablishmentsPresenter,
                    delegate: EstablishmentsViewController) {
        
        let controller: EstablishmentsFilterViewController =
            EstablishmentsFilterViewController(nibName: "EstablishmentsFilterViewController", bundle: nil)
        controller.presenter = presenter
        controller.delegate = delegate
        
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
    
    func showQRCode(at navigation: UINavigationController, establishments: Establishments) {
        
        let controller: EstablishmentsQRCodeViewController =
            EstablishmentsQRCodeViewController(nibName: "EstablishmentsQRCodeViewController", bundle: nil)
        
        controller.establishments = establishments
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
    
    // ****************************************
    
    func show(at viewController: UIViewController) {
        
        let controller: EstablishmentsViewController =
            EstablishmentsViewController(nibName: "EstablishmentsViewController", bundle: nil)
        controller.viewController = viewController
        
        viewController.show(controller, sender: nil)
    }
    
    func showFilter(at viewController: UIViewController, presenter: EstablishmentsPresenter,
                    delegate: EstablishmentsViewController) {
        
        let controller: EstablishmentsFilterViewController =
            EstablishmentsFilterViewController(nibName: "EstablishmentsFilterViewController", bundle: nil)
        controller.presenter = presenter
        controller.delegate = delegate
        
        viewController.show(controller, sender: nil)
    }
    
    func showDetail(at viewController: UIViewController, establishments: Establishments) {
        
        let controller: EstablishmentsDetailViewController =
            EstablishmentsDetailViewController(nibName: "EstablishmentsDetailViewController", bundle: nil)
        
        controller.establishments = establishments
        controller.viewController = viewController
        viewController.show(controller, sender: nil)
    }
    
    func showQRCode(at viewController: UIViewController, establishments: Establishments) {
        
        let controller: EstablishmentsQRCodeViewController =
            EstablishmentsQRCodeViewController(nibName: "EstablishmentsQRCodeViewController", bundle: nil)
        
        controller.establishments = establishments
        controller.viewController = viewController
        viewController.show(controller, sender: nil)
    }
}
