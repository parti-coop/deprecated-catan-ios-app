//
//  PartiAuthService.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol PartiAuthServiceDelegate: class {
    func onPartiAuthSuccess(accessToken: String?, refreshToken: String?, expiresIn: String?)
    func onPartiAuthRequireSignUp(socialAccessToken: String)
    func onPartiAuthInvalidToken()
    func onPartiAuthUnknownError(error: Error)
}

class PartiAuthService {
    weak var delegate: PartiAuthServiceDelegate?
    
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
    
    required init(delegate: PartiAuthServiceDelegate) {
        self.delegate = delegate
    }
    
    func auth(socialAccessToken: String) {
        let congiuration = Environment.sharedConfiguration
        sessionManager.request(APIClient.fullUrl("/oauth/token"),
                          method: .post,
                          parameters: [
                            "provider": "facebook", "assertion": socialAccessToken,
                            "grant_type": "assertion",
                            "client_id": congiuration.get(CatanAPIKeys.clientId)!,
                            "client_secret": congiuration.get(CatanAPIKeys.clientSecret)!],
                          encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                switch(response.result) {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        strongSelf.delegate?.onPartiAuthSuccess(accessToken: json["access_token"].string, refreshToken: json["refresh_token"].string, expiresIn: json["expires_in"].string)
                    }
                    break
                case .failure(let error):
                    debugPrint(response)
                    guard let httpStatusCode = response.response?.statusCode else {
                        debugPrint(response)
                        debugPrint(error)
                        strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                        return
                    }
                    
                    switch(httpStatusCode) {
                    case 401:
                        guard let value = response.result.value,
                            let response_error_code = JSON(value)["error"].string else {
                                strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                                return
                        }
                        switch(response_error_code) {
                        case "need_nickname":
                            guard let httpBody = response.request?.httpBody,
                                let socialAccessToken = JSON(data: httpBody)["assertion"].string else {
                                    debugPrint("not found assertion param")
                                    strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                                    return
                            }
                            strongSelf.delegate?.onPartiAuthRequireSignUp(socialAccessToken: socialAccessToken)
                        case "fail_external_auth":
                            debugPrint("invalid socail access token")
                            strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                            return
                        default:
                            debugPrint("unkonw server error : \(response_error_code)")
                            strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                            return
                        }
                    default:
                        debugPrint(response)
                        strongSelf.delegate?.onPartiAuthUnknownError(error: error)
                        return
                    }
                }
        }
    }
}

