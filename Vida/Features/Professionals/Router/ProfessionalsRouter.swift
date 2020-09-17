//
//  ProfessionalsRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

final class ProfessionalsRouter {
    
    func show(at navigation: UINavigationController) {
        
        let controller: ProfessionalsViewController =
            ProfessionalsViewController(nibName: "ProfessionalsViewController", bundle: nil)
        
        navigation.show(controller, sender: nil)
    }
    
    func showDetail(at navigation: UINavigationController, professional: Professional) {
        
        let controller: ProfessionalsDetailViewController =
            ProfessionalsDetailViewController(nibName: "ProfessionalsDetailViewController", bundle: nil)
        
        controller.professional = professional
        navigation.show(controller, sender: nil)
    }
    
    func showFilter(at navigation: UINavigationController, presenter: ProfessionalsPresenter,
                    delegate: ProfessionalsViewController) {
        
        let controller: ProfessionalsFilterViewController =
            ProfessionalsFilterViewController(nibName: "ProfessionalsFilterViewController", bundle: nil)
        controller.presenter = presenter
        controller.delegate = delegate
        
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
}
