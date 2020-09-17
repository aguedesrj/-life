//
//  ScanQrCodeViewProtocol.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol ScanQrCodeViewProtocol: class {
    func returnSuccessScanQrCode(establishment: Establishments)
    func returnErrorScanQrCode(message: String)
}
