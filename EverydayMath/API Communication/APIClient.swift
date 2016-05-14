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
    
    static let baseUrl = "http://localhost:5000"
    
    static func getConfigurationForTask(task: Task) -> Promise<TaskRunConfiguration> {
        let user: String
        if let storedUser = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String {
            user = storedUser
        } else {
            user = NSUUID().UUIDString
            NSUserDefaults.standardUserDefaults().setObject(user, forKey: "user")
        }
        
        let language = NSLocale.preferredLanguages().first ?? ""
        let isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as! Bool
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        return Alamofire.request(.GET, self.baseUrl + "/api/start", parameters: ["task": task.identifier, "user": user, "language":language, "metric": isMetric, "version": versionNumber], encoding: ParameterEncoding.URL)
            .promiseUnboxableJSON()
            .then({ dictionary -> TaskRunConfiguration in
                do {
                    let config: TaskRunConfiguration = try UnboxOrThrow(dictionary)
                    return config
                } catch {
                    let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: "JSON deserialization failed"]
                    throw NSError(domain: Error.Domain, code: Error.Code.JSONSerializationFailed.rawValue, userInfo: userInfo)
                }
            }).then({ configuration in
                // gather ImageQuestions to load images 
                let numQuestions = configuration.questions.flatMap({ $0 as? ImageQuestionConfiguration }).filter({ $0.imagePath != nil})
                
                var imagePromises = [Promise<Void>]()
                for numQuestion in numQuestions {
                    imagePromises.append(Alamofire.request(.GET, self.baseUrl + numQuestion.imagePath!).promiseImage().then({ image in
                        numQuestion.image = image
                    }))
                }
                
                return when(imagePromises).then({ a in
                    return configuration
                }).recover { err in
                    return configuration
                }
            })
    }
    
    static func uploadTaskRunLog(log: TaskRunLog) -> Promise<Void> {
        return Alamofire.request(.POST, self.baseUrl + "/api/updateTaskRun", parameters: log.serialize(), encoding: ParameterEncoding.JSON)
            .promiseResponse()
    }  
}