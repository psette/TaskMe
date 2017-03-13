//
//  LoginViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/9/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func LoginAttempted(_ sender: Any) {
        if let email = self.emailText.text, let password = self.passwordText.text {
            if email == "" && password == ""{
                self.showErrorMessage(message: "Email and password are both empty.")
            }else if email == ""{
                self.showErrorMessage(message: "Email can't be empty.")
                return
            } else if password == ""{
                self.showErrorMessage(message: "Password can't be empty.")
                return
            }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.showErrorMessage(message: error.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "LogInNow", sender: self)
            }
        } else {
            self.showErrorMessage(message: "Check email and password.")
        }
    }
}
