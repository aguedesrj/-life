//
//  Request.swift
//  Vida
//
//  Created by Vida on 10/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

final class Request {
    static let sharedInstance: RequestClientProtocol = AlamofireRequestClient()
}
