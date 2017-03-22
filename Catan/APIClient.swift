//
//  APIClient.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import SwiftyConfiguration

class APIClient {
    static let defaultManager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "parti.dev": .disableEvaluation
        ]
        
        var manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        let congiuration = Environment.sharedConfiguration
        let handler = APIHandler(
            clientID: congiuration.get(CatanAPIKeys.clientId)!,
            baseURL: congiuration.get(CatanAPIKeys.baseURL)!,
            userSession: UserSession.sharedInstance
        )
        
        manager.adapter = handler
        manager.retrier = handler
        
        return manager
    }()
    
    static func fullUrl(_ path: String) -> URLConvertible {
        return Environment.sharedConfiguration.get(CatanAPIKeys.baseURL)!.appendingPathComponent(path)
    }
}
