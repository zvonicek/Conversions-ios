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
                        reject(Error.errorWithCode(1, failureReason: "JSON deserialization failed"))
                    }
            }
        }
    }
    
    func promiseImage() -> Promise<UIImage?> {
        return Promise { resolve, reject in
            self.validate()
                .responseData({ response in
                    switch response.result {
                    case .Success(let data):
                        resolve(UIImage(data: data))
                    case .Failure(let error):
                        reject(error)
                    }
                })
        }
    }
}