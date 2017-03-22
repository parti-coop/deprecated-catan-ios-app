//
//  UserSession.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class UserSession {
    static let sharedInstance = UserSession()
    
    var accessToken:String? {
        get {
            return KeychainHelper.get(service: .auth, "accessToken")
        }
        set(accessToken) {
            KeychainHelper.save(service: .auth, "accessToken", accessToken)
        }
    }
    var refreshToken:String? {
        get {
            return KeychainHelper.get(service: .auth, "refreshToken")
        }
        set(refreshToken) {
            KeychainHelper.save(service: .auth, "refreshToken", refreshToken)
        }
    }
    var expiresIn:String? {
        get {
            return KeychainHelper.get(service: .auth, "expiresIn")
        }
        set(expiresIn) {
            KeychainHelper.save(service: .auth, "expiresIn", expiresIn)
        }
    }
    
    func signIn(accessToken: String?, refreshToken: String?, expiresIn: String?) {
        refreshKeys(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn)
        UserDefaults.standard.set("SignedIn", forKey: "userSignedIn")
        UserDefaults.standard.synchronize()
    }
    
    func signOut() -> Bool {
        if KeychainHelper.destroyAll(service: .auth) {
            UserDefaults.standard.removeObject(forKey: "userSignedIn")
            UserDefaults.standard.synchronize()
            return true
        } else {
            return false
        }
    }
    
    func refreshKeys(accessToken: String?, refreshToken: String?, expiresIn: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
    
    func isSignedOut() -> Bool {
        return UserDefaults.standard.object(forKey: "userSignedIn") == nil
    }
    
    func isSignedIn() -> Bool {
        return !isSignedOut()
    }
}
