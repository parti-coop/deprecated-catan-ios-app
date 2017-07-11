//
//  MainNavigationController.swift
//  Catan
//
//  Created by rest515 on 2017. 7. 11..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if true || UserSession.sharedInstance.isSignedIn() {
            let homeController = HomeController()
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: {})
    }
}
