//
//  KeyChainHelper.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import KeychainAccess

class KeychainHelper {
    enum KeyChainService: String {
        case auth
    }
    
    static func save(service: KeyChainService, _ key: String, _ value: String?) {
        guard let strongValue = value else { return }
        Keychain(service: service.rawValue)[key] = strongValue
    }
    
    static func destroyAll(service: KeyChainService) -> Bool {
        let keychain = Keychain(service: service.rawValue)
        do {
            try keychain.removeAll()
            return true
        } catch {
            return false
        }
    }
    
    static func get(service: KeyChainService, _ key : String) -> String? {
        let keychain = Keychain(service: service.rawValue)
        do {
            return try keychain.get(key)
        } catch {
            return nil
        }
    }
}
