//
//  LoginViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/9/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func forgotPassoword(sender: AnyObject)
    {
        if self.emailText.text == ""
        {
            showErrorMessage(message: "Please enter an email.")
            
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailText.text!, completion: { (error) in
                
                var message = ""
                
                if error != nil
                {
                    message = (error?.localizedDescription)!
                }
                else
                {
                    message = "Password reset email sent."
                    self.emailText.text = ""
                }
                
                self.showErrorMessage(message: message)
            })
        }
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
                UserInfoLocal.Email = (user?.email)!
                UserInfoLocal.FirstName = (user?.displayName)!
            
                UserInfoLocal.userID = (user?.uid)!
            
                self.performSegue(withIdentifier: "LogInNow", sender: self)
            }
        } else {
            self.showErrorMessage(message: "Check email and password.")
        }
    }
}
