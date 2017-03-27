//
//  CurrentUserDataManager.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CurrentUserDataManager {
    static let sharedInstance = CurrentUserDataManager()
    
    func fetch(completionHandler: @escaping (_ currentUser : CurrentUser?, _ error: Error?) -> () = { e -> () in }) {
        APIClient.defaultManager.request(APIClient.fullUrl("/api/v1/users/me"),
                                         method: .get,
                                         encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                switch(response.result) {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let currentUser = strongSelf.asModel(json: json)
                        completionHandler(currentUser, nil)
                    }
                    break
                case .failure(let error):
                    debugPrint(response)
                    debugPrint(error)
                    completionHandler(nil, error)
                }
        }
    }

    private func asModel(jsonUser: JSON) -> CurrentUser? {
        let currentUser = CurrentUser()
        currentUser.id = jsonUser["id"].int
        currentUser.email = jsonUser["email"].string
        currentUser.nickname = jsonUser["nickname"].string
        currentUser.imageUrl = jsonUser["imageUrl"].string
        return currentUser
    }
}

