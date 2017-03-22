//
//  Environment.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import SwiftyConfiguration

struct Environment {
    static var sharedConfiguration: Configuration {
        let plistPath = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
        return Configuration(plistPath: plistPath)!
    }
}
