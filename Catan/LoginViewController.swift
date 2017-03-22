//
//  LoginViewController.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, SocialAuthServiceDelegate, PartiAuthServiceDelegate {
    
    @IBOutlet var facebookLoginButton: UIButton!
    @IBOutlet var indicatorView: UIView!
    
    var facebookAuthService: FacebookAuthService!
    var partiAuthService: PartiAuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.layer.cornerRadius = 10
        styleEnableFacebookButton()
        
        facebookAuthService = FacebookAuthService(delegate: self)
        partiAuthService = PartiAuthService(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInFacebookAction(_ sender: AnyObject) {
        styleDisableFacebookButton()
        facebookAuthService.auth(self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Style
    
    func styleDisableFacebookButton() {
        facebookLoginButton.isEnabled = false
        facebookLoginButton.alpha = 0.5;
        self.indicatorView.isHidden = false
    }
    
    func styleEnableFacebookButton() {
        facebookLoginButton.isEnabled = true
        facebookLoginButton.alpha = 1
        self.indicatorView.isHidden = true
    }
    
    // Social Auth
    
    func onSocialAuthError(error: Error) {
        alertUnknownError()
        debugPrint(error)
        styleEnableFacebookButton()
    }
    
    func onSocialAuthNoEmailError() {
        alert("로그인에 실패했습니다. 페이스북에서 이메일을 받아 올 수 없습니다")
        styleEnableFacebookButton()
    }
    
    func onSocialAuthCancel() {
        alert("로그인 취소하셨습니다")
        styleEnableFacebookButton()
    }
    
    func onSocialAuthSuccess(token: String) {
        partiAuthService.auth(socialAccessToken: token)
    }
    
    // Parti Auth
    
    func onPartiAuthSuccess(accessToken: String?, refreshToken: String?, expiresIn: String?) {
        UserSession.sharedInstance.signIn(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
        alert("로그인되었습니다.") { [weak self] _ in
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func onPartiAuthRequireSignUp(socialAccessToken: String) {
        alert("가입되지 않은 사용자입니다. 신규 가입은 개발 진행 중입니다. token - \(socialAccessToken)")
        styleEnableFacebookButton()
    }
    
    func onPartiAuthInvalidToken() {
        alert("페이스북 로그인이 실패했습니다")
        styleEnableFacebookButton()
    }
    
    func onPartiAuthUnknownError(error: Error) {
        alertUnknownError()
        debugPrint(error)
        styleEnableFacebookButton()
    }
}

