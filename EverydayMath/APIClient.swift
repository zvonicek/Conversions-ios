//
//  APIClient.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 19.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Unbox

class APIClient {
    
//    static let baseUrl = "http://localhost:5000"
    static let baseUrl = "http://math.hoover.petrzvonicek.cz"
    
    static func getConfigurationForTask(task: Task) -> Promise<TaskConfiguration> {
        let user: String
        if let storedUser = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String {
            user = storedUser
        } else {
            user = NSUUID().UUIDString
            NSUserDefaults.standardUserDefaults().setObject(user, forKey: "user")
        }
        
        let language = NSLocale.preferredLanguages().first ?? ""
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        return Alamofire.request(.GET, self.baseUrl + "/api/start", parameters: ["task": task.identifier, "user": user, "language":language, "version": versionNumber], encoding: ParameterEncoding.URL)
            .promiseUnboxableJSON()
            .then({ dictionary -> TaskConfiguration in
                do {
                    let config: TaskConfiguration = try UnboxOrThrow(dictionary)
                    return config
                } catch {
                    throw Error.errorWithCode(1, failureReason: "JSON deserialization failed")
                }
            }).then({ configuration in
                let numQuestions = configuration.questions.flatMap({ $0 as? ImageQuestionConfiguration }).filter({ $0.imagePath != nil})
                
                var imagePromises = [Promise<Void>]()
                for numQuestion in numQuestions {
                    imagePromises.append(Alamofire.request(.GET, self.baseUrl + numQuestion.imagePath!).promiseImage().then({ image in
                        numQuestion.image = image
                    }))
                }
                
                return when(imagePromises).then({ a in
                    return configuration
                })
            })
    }
    
    static func uploadTaskRunLog(log: TaskRunLog) -> Promise<Void> {
        return Alamofire.request(.POST, self.baseUrl + "/api/updateTaskRun", parameters: log.serialize(), encoding: ParameterEncoding.JSON)
            .promiseResponse()
    }  
}