//
//  AlamofireRequestClient.swift
//  Vida
//
//  Created by Vida on 10/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireRequestClient: RequestClientProtocol {
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func request(method: RequestHTTPMethod, url: String, urlParameters: [String : String]?, headers: [String : String]?, parameters: [String : Any]?, success: @escaping (Any) -> Void, failure: @escaping (RequestError) -> Void) {
        
        switch method {
        case .get:
            
            appDelegate.manager.request(url, method: .get, parameters: urlParameters ?? [:], encoding: URLEncoding.queryString,
                              headers: self.setServiceHeaders(with: headers))
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            success(response.value!)
                        } else {
                            let requestError: RequestError? = RequestError.parse(json: JSON(response.value!))
                            if (requestError != nil) {
                                failure(requestError!)
                            } else {
                                failure(RequestError.init(httpStatusCode: (response.response?.statusCode)!,
                                                          description: Constrants.messageSystemUnavailable))
                            }
                        }
                    case .failure(let error):
                        if response.response != nil {
                            failure(RequestError.init(httpStatusCode: (response.response?.statusCode)!,
                                                      description: error.localizedDescription))
                        } else {
                            failure(RequestError.init(description: Constrants.messageSystemUnavailable))
                        }
                    }
            }
        case .post:
            appDelegate.manager.request(url, method: .post, parameters: parameters ?? [:], encoding: JSONEncoding.default,
                              headers: self.setServiceHeaders(with: headers))
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            success(response.value!)
                        } else {
                            let requestError: RequestError? = RequestError.parse(json: JSON(response.value!))
                            if (requestError != nil) {
                                failure(requestError!)
                            } else {
                                failure(RequestError.init(httpStatusCode: (response.response?.statusCode)!,
                                                          description: Constrants.messageSystemUnavailable))
                            }
                        }
                    case .failure(let error):
                        if response.response != nil {
                            failure(RequestError.init(httpStatusCode: (response.response?.statusCode)!,
                                                      description: error.localizedDescription))
                        } else {
                            failure(RequestError.init(description: Constrants.messageSystemUnavailable))
                        }
                    }
            }
        }
    }
    
    /// Método responsável por incluir no header atributos necessários para as requests.
    ///
    /// - Parameter headers: lista de atributos
    /// - Returns: atributos no header
    private func setServiceHeaders(with headers:[String : String]?) -> [String : String]? {
        // incluir o token no header...
        if appDelegate.login != nil {
            var serviceHeaders = ["token" : appDelegate.login?.token]
            
            if headers != nil {
                for key in headers!.keys {
                    serviceHeaders[key] = headers![key]
                }
            }
            
            print("Alamofire Header: \(serviceHeaders)")
            return (serviceHeaders as! [String : String])
        }
        return headers
    }
}
