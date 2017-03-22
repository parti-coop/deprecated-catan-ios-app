//
//  CommonAlert.swift
//  Catan
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert =  UIAlertController(title: "안내", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: handler)
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    func alertUnknownError() {
        self.alert("오류가 발생하였습니다.")
    }
}
