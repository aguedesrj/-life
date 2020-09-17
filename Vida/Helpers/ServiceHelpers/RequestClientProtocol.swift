//
//  RequestClientProtocol.swift
//  Vida
//
//  Created by Vida on 10/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestClientProtocol {
    func request(method: RequestHTTPMethod,
                 url: String,
                 urlParameters: [String : String]?,
                 headers: [String : String]?,
                 parameters: [String : Any]?,
                 success: @escaping (Any) -> Void,
                 failure: @escaping (RequestError) -> Void)
}
