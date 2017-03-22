//
//  SocialAuthServiceDelegate.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

protocol SocialAuthServiceDelegate: class {
    func onSocialAuthError(error: Error)
    func onSocialAuthNoEmailError()
    func onSocialAuthCancel()
    func onSocialAuthSuccess(token: String)
}
