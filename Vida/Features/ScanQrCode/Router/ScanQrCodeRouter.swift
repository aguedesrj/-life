//
//  ScanQrCodeRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

final class ScanQrCodeRoute {
    
    func show(at navigation: UINavigationController) {
        let controller: ScanQrCodeViewController =
            ScanQrCodeViewController(nibName: "ScanQrCodeViewController", bundle: nil)
        
        controller.modalPresentationStyle = .fullScreen
        navigation.present(controller, animated: true, completion: nil)
    }
    
    func showVerified(at viewController: UIViewController, establishments: Establishments) {
        
        let controller: ScanQrCodeVerifiedViewController =
            ScanQrCodeVerifiedViewController(nibName: "ScanQrCodeVerifiedViewController", bundle: nil)
        controller.establishments = establishments
        
        viewController.show(controller, sender: nil)
    }
    
    func showStoresPartner(at viewController: UIViewController) {
        let controller: StoresPartnerViewController =
            StoresPartnerViewController(nibName: "StoresPartnerViewController", bundle: nil)
        
        viewController.show(controller, sender: nil)
    }
}
