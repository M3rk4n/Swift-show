//
//  ViewController.swift
//  ICoffee
//
//  Created by student on 12/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // provadi nastaveni elementu
        setUpElements()
    }
    
    func setUpElements(){
        Utilities.styleNameL(nameLabel)
        Utilities.styleFilledB(signUpButton)
        Utilities.styleHollowB(loginButton)
        
    }
}

