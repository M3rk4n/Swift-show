//
//  CoffeViewController.swift
//  ICoffee
//
//  Created by student on 11/06/2020.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import FirebaseStorage
import Firebase
import FirebaseUI
import FirebaseDatabase

class CoffeViewController: UIViewController {
    
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var buyButton: UIButton!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var coffeeTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        //nameLabel.text = coffeeList[myIndex]
        coffeeTitle.title = coffeeList[myIndex].name
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child(coffeeList[myIndex].urlPicture)
        
        imageView.sd_setImage(with: ref)
        
        textView.text = coffeeList[myIndex].note
    }
    
    func setUpElements(){
        Utilities.styleFilledB(buyButton)
    }
    
    /*
     func downloadImage(){
     let storage = Storage.storage()
     let storageRef = storage.reference()
     
     let ref = storageRef.child("coffee.png")
     imageView.sd_setImage(with: ref)
     
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of anz resources that can be recreated
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyButtonClicked(_ sender: Any) {
        showSafari(for: coffeeList[myIndex].urlToBuy)
    }
    
    func showSafari(for url: String){
        guard let url = URL(string: url) else {
            //invalid url
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
}

