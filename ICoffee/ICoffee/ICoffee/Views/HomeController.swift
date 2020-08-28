//
//  HomeController.swift
//  ICoffee
//
//  Created by student on 12/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var coffeeListButton: UIButton!
    
    @IBOutlet weak var findCaffeButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // element options
        setUpElements()
    }
    
    // to the coffe list
    @IBAction func coffeLButtonTapped(_ sender: Any) {
        let listViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.listViewC) as? ListViewController
        
        self.view.window?.rootViewController = listViewC
        self.view.window?.makeKeyAndVisible()
        
    }
    // to the caffe finder
    @IBAction func findCaffeButtonTapeed(_ sender: Any) {
        let findC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.findC) as? findCaffeController
        
        self.view.window?.rootViewController = findC
        self.view.window?.makeKeyAndVisible()
        
        
    }
    // logout
    @IBAction func logoutButtonTapped(_  sender: Any) {
        createAlert(title: "Warning", message: "Are you sure you want to logout ?", handlerYES: { action in
            let viewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.viewC) as? ViewController
            
            self.view.window?.rootViewController = viewC
            self.view.window?.makeKeyAndVisible()
            coffeeList.removeAll()
            
        }, handlerNO: { action in
        })
        
    }
    
    func setUpElements(){
        // styl jednotlivých elementů
        Utilities.styleHollowB(coffeeListButton)
        Utilities.styleHollowB(findCaffeButton)
        Utilities.styleFilledB(logoutButton)
    }
    
    func createAlert(title: String, message:String, handlerYES: ((UIAlertAction) -> Void)?, handlerNO: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive, handler: handlerYES)
        let actionNo = UIAlertAction(title: "No", style: .cancel, handler: handlerNO)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
