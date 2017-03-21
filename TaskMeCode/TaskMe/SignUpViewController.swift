//
//  SignUpViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/9/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
   
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBAction func AttemptSignUp(_ sender: Any) {
        
        let email = self.emailField.text
        
        if(email == ""){
            self.showErrorMessage(message: "Email can't be empty.")
            return
        }
        
        let firstNameText = self.firstName.text
        
        if(firstNameText == ""){
            self.showErrorMessage(message: "First name can't be empty.")
            return
        }
        
        let lastNameText = self.lastName.text
        
        if(lastNameText == ""){
            self.showErrorMessage(message: "Last name can't be empty.")
            return
        }
        
        let password = self.passwordField.text
        if(password == ""){
            self.showErrorMessage(message: "Password can't be empty.")
            return
        }
        
        let passwordConfirm = self.confirmPasswordField.text
        if(passwordConfirm == ""){
            self.showErrorMessage(message: "Confirm password can't be empty.")
            return
        }
        
        if(password != passwordConfirm){
            self.showErrorMessage(message: "Passwords do not match.")
            passwordField.text = ""
            confirmPasswordField.text = ""
            return
        }
        let ref = FIRDatabase.database().reference()
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                if error != nil {
                    self.showErrorMessage(message: (error?.localizedDescription)!)
                    return
                }   else {

                    let newUser = [
                        "firstName": firstNameText,
                        "lastName": lastNameText,
                        "email" : email
                    ]

                    ref.child("users").child((user?.uid)!).setValue(newUser)
                }
            
                self.performSegue(withIdentifier: "LogInNow", sender: self)

        }
        

    }
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
