//
//  AlamoPromise.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 04.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Unbox

extension Alamofire.Request {
    func promiseUnboxableJSON() -> Promise<UnboxableDictionary> {
        return Promise { resolve, reject in
            self.validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success(let dictionary) where dictionary is UnboxableDictionary:
                        resolve(dictionary as! UnboxableDictionary)
                    case .Failure(let error):
                        reject(error)
                    default:
                        let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: "JSON deserialization failed"]
                        reject(NSError(domain: Error.Domain, code: Error.Code.JSONSerializationFailed.rawValue, userInfo: userInfo))
                    }
            }
        }
    }
    
    func promiseImage() -> Promise<UIImage?> {
        return Promise { resolve, reject in
            self.validate()
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .Success(let data):
                        resolve(UIImage(data: data))
                    case .Failure(let error):
                        reject(error)
                    }
                })
        }
    }
    
    func promiseResponse() -> Promise<Void> {
        return Promise { resolve, reject in
            self.validate()
                .response { request, response, data, error in
                    if let error = error {
                        reject(error)
                    } else {
                        resolve()
                    }
                }
        }
    }
}