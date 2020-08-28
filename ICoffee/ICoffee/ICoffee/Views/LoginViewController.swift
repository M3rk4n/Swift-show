//
//  LoginViewController.swift
//  ICoffee
//
//  Created by student on 12/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // provadi nastaveni elementu
        
        setUpElements()
    }
    
    func setUpElements(){
        
        errorLabel.alpha = 0 // schovani labelu error
        
        // styl jednotlivých elementů
        Utilities.styleTextF(loginTextField)
        Utilities.styleTextF(passwordTextField)
        Utilities.styleFilledB(loginButton)
    }
    
    func validateF() -> String? {
        
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Fill all field please"
        }
        
        let cPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.passwordValidation(cPassword) == false {
            return "Pleas check again your password is at leat 8 chars and contains a special character and number"
        }
        
        return nil
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // validation
        let error = validateF()
        
        if error != nil {
            // error message
            sError(error!)
        } else {
            
            //clean text f..
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //sign in
            Auth.auth().signIn(withEmail: email, password: password){(result, error) in
                if error != nil {
                    //bad sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    //home vc
                    let homeViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.homeViewC) as? HomeController
                    
                    self.view.window?.rootViewController = homeViewC
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    //show our error
    func sError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
