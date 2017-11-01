//
//  RegisterViewController.swift
//  ChabokTest
//
//  Created by Parvin Mehrabani on 8/10/1396 AP.
//  Copyright © 1396 Parvin Mehrabani. All rights reserved.
//

import UIKit
import AdpPushClient

class RegisterViewController: UIViewController {

    @IBOutlet weak var UserIdTextField: UITextField!
    var manager = PushClientManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerBtnClick(_ sender: UIButton) {
        
        let UserId: String = UserIdTextField.text!
        let registerUser = self.manager.registerUser(UserId)
        
        if !registerUser {
            print("Error : \(self.manager.failureError)")
            return
        }
        else
        {
            performSegue(withIdentifier: "showView", sender: self)
        }
    }
}
