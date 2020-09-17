//
//  ScanQrCodePresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

class ScanQrCodePresenter {
    
    fileprivate var view: ScanQrCodeViewProtocol
    fileprivate var service: EstablishmentsService
    
    init(view: ScanQrCodeViewProtocol) {
        self.view = view
        self.service = EstablishmentsService()
    }
}

extension ScanQrCodePresenter {
    
    func getEstablishmentsByQrCode(qrCode: String) {
        
        self.service.getEstablishmentsByQrCode(qrCode: qrCode, success: { (result) in
            //
            self.view.returnSuccessScanQrCode(establishment: result)
        }) { (error) in
            self.view.returnErrorScanQrCode(message: error.description)
        }
    }
}
