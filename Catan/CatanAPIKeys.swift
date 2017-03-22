//
//  PartiAPIKeys.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import SwiftyConfiguration

class CatanAPIKeys: Keys {
    static let baseURL = Key<URL>("Catan.API.BaseURL")
    static let clientId  = Key<String>("Catan.API.clientId")
    static let clientSecret  = Key<String>("Catan.API.clientSecret")
}
