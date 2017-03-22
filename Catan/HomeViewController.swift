//
//  ViewController.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserSession.sharedInstance.isSignedOut() {
            if let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                self.present(loginController, animated: true)
            }
        } else {
            CurrentUserDataManager.sharedInstance.fetch() { [weak self] (currentUser, error) in
                if let nickname = currentUser?.nickname {
                    self?.welcomeLabel.text = "어서오세요.\n\(nickname)님!"
                    self?.welcomeLabel.numberOfLines = 2;
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOutAction(_ sender: AnyObject) {
        if UserSession.sharedInstance.signOut() {
            alert("로그아웃 되었습니다") { _ in
                self.viewDidAppear(true)
            }
        } else {
            alertUnknownError()
        }
    }
}

