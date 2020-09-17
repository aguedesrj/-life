//
//  TutorialRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

final class TutorialRouter {
    
    func show(at navigation: UINavigationController) {
        let controller: TutorialViewController =
            TutorialViewController(nibName: "TutorialViewController", bundle: nil)
        
        navigation.show(controller, sender: nil)
    }
    
    func showDetail(at controller: UIViewController, indexSelected: Int, tutorialCard: TutorialCard) {
        let viewController: TutorialDetailViewController =
            TutorialDetailViewController(nibName: "TutorialDetailViewController", bundle: nil)
        
        viewController.indexSelected = indexSelected
        viewController.tutorialCard = tutorialCard
        
        viewController.modalPresentationStyle = .fullScreen
        controller.present(viewController, animated: true, completion: nil)
    }
    
    func presentDetailProduct(at navigation: UINavigationController) {
        let controller: DetailProductViewController =
            DetailProductViewController(nibName: "DetailProductViewController", bundle: nil)
        
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
}
