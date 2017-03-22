//
//  APIHandler.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?, _ expiresIn: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "parti.dev": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    private let lock = NSLock()
    
    private var clientID: String
    private var baseURL: URL
    private var userSession: UserSession
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(clientID: String, baseURL: URL, userSession: UserSession) {
        self.clientID = clientID
        self.baseURL = baseURL
        self.userSession = userSession
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let accessToken = userSession.accessToken {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, userSession.refreshToken != nil {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken, expiresIn in
                    guard let strongSelf = self else { return }
                    defer { strongSelf.requestsToRetry.removeAll() }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken, let refreshToken = refreshToken, let expiresIn = expiresIn {
                        UserSession.sharedInstance.refreshKeys(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
                        
                    }
                    strongSelf.requestsToRetry.forEach { $0(false, 0.0) }
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        guard let refreshToken = userSession.refreshToken else { completion(false, nil, nil, nil); return }
        
        isRefreshing = true
        
        let parameters: [String: String] = [
            "refresh_token": refreshToken,
            "client_id": clientID,
            "grant_type": "refresh_token"
        ]
        
        sessionManager.request(APIClient.fullUrl("/oauth/token"),
                               method: .post,
                               parameters: parameters,
                               encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { completion(false, nil, nil, nil); return }
                
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(true, json["access_token"].string, json["refresh_token"].string, String(describing: json["expires_in"].int))
                } else {
                    completion(false, nil, nil, nil)
                }
                
                strongSelf.isRefreshing = false
        }
    }
}

