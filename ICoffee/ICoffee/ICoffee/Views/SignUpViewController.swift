//
//  SIngUpViewController.swift
//  ICoffee
//
//  Created by student on 12/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTexField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // provadi nastaveni elementu
        setUpElements()
    }
    
    func setUpElements(){
        
        errorLabel.alpha = 0 // schovani labelu error
        
        // styl jednotlivých elementů
        Utilities.styleTextF(firstNameTextField)
        Utilities.styleTextF(lastNameTextField)
        Utilities.styleTextF(emailTextField)
        Utilities.styleTextF(passwordTexField)
        Utilities.styleFilledB(signUpButton)
        
    }
    //controlling txtFields -> error or nil
    func validateF() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Fill all field please"
        }
        
        let cPassword = passwordTexField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.passwordValidation(cPassword) == false {
            return "Pleas check again your password is at leat 8 chars and contains a special character and number"
        }
        
        return nil
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        
        //validation of the fields
        let error = validateF()
        
        if error != nil {
            // error message
            sError(error!)
        } else {
            
            //data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTexField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //creating user
            Auth.auth().createUser(withEmail: email, password: password) { (result, e) in
                
                //checking e
                if e != nil{
                    
                    //some error
                    self.sError("Error ")
                    
                } else{
                    //succesfull
                    let db = Firestore.firestore()
                    
                    db.collection("Users").addDocument(data: ["first_name":firstName, "lastName":lastName, "uid": result!.user.uid]){ (error) in
                        
                        //show error
                        if e != nil{
                            self.sError("User data couldn't be saved")
                        }
                    }
                    // to welcome page
                    self.transitionHome()
                }
            }
            
        }
        
    }
    //show our error
    func sError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionHome(){
        let homeViewC = storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.homeViewC) as? HomeController
        
        view.window?.rootViewController = homeViewC
        view.window?.makeKeyAndVisible()
        
    }
    
}
