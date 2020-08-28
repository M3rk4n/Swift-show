//
//  Utilities.swift
//  ICoffee
//
//  Created by student on 13/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextF(_ textfield:UITextField) {
        
        // Vytvoreni cary pod textove pole a jeji init
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.brown.cgColor
        // odebere ohraniceni textoveho pole
        textfield.borderStyle = .none
        // prida caru pod textove pole
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleNameL(_ label:UILabel){
        label.tintColor = UIColor.brown
    }
    
    static func styleFilledB(_ button:UIButton) {
        
        // plne tlacitko bez okraje
        button.backgroundColor = UIColor.brown
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowB(_ button:UIButton) {
        
        // prazdne tlacitko s okrajem
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brown.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.brown
    }
    
    static func passwordValidation(_ password : String) -> Bool {
        let pTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return pTest.evaluate(with: password)
    }
    
}
