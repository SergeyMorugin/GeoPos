//
//  AuthViewController.swift
//  GeoPos
//
//  Created by Matthew on 09.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    var storeService: DBService?
    var onLogin: (() -> Void)?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignupClick(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
            else { return }
        guard let store = storeService else { return }
        
        let user = User(login: login, password: password)
        
        if store.updateOrCreate(user: user) == .created {
            showAlert(withMessage: "Your account has been created.")
        } else {
            showAlert(withMessage: "Your password has been updated.")
        }
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        if let store = storeService,
           store.authUser(
            login: loginTextField.text ?? "",
            password: passwordTextField.text ?? "") {
            UserDefaults.standard.set(true, forKey: "isLogin")
            onLogin?()
        } else {
            showAlert(withMessage: "Wrong credentials!")
        }
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
