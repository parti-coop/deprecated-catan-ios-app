//
//  FacebookAuthService.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class FacebookAuthService {
    weak var delegate: SocialAuthServiceDelegate?
    let fbLoginManager = FBSDKLoginManager()
    
    required init(delegate: SocialAuthServiceDelegate) {
        self.delegate = delegate
    }
    
    func auth(_ viewController: UIViewController) {
        fbLoginManager.logIn(withReadPermissions: ["email"], from: viewController) {
            [weak self] (result: FBSDKLoginManagerLoginResult?, error: Error?) -> Void in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.fbLoginManager.logOut()
                strongSelf.delegate?.onSocialAuthError(error: error)
                return
            }
            if let result = result {
                if result.isCancelled {
                    strongSelf.fbLoginManager.logOut()
                    strongSelf.delegate?.onSocialAuthCancel()
                    return
                } else {
                    if result.grantedPermissions.contains("email")  {
                        strongSelf.delegate?.onSocialAuthSuccess(token: result.token.tokenString)
                        return
                    } else {
                        strongSelf.delegate?.onSocialAuthNoEmailError()
                        return
                    }
                }
            }
        }
    }
}
