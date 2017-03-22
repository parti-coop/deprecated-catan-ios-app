//
//  ViewController.swift
//  test
//
//  Created by Youngmin Kim on 2017. 3. 22..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ok(_ sender: AnyObject) {
        let i = self.storyboard!.instantiateViewController(withIdentifier: "vc")
        self.present(i, animated: false, completion: nil)
    }

}

