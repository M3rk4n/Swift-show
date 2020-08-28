//
//  ListViewController.swift
//  ICoffee
//
//  Created by student on 18/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

var myIndex = 0
var coffeeList: [MyCoffee] = []

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addCoffeeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        let homeViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.homeViewC) as? HomeController
        
        self.view.window?.rootViewController = homeViewC
        self.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.addC) as? AddCoffeeController
        
        self.view.window?.rootViewController = addC
        self.view.window?.makeKeyAndVisible()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffeeCell", for: indexPath)
        cell.textLabel!.text = coffeeList[indexPath.row].name
        cell.textLabel?.textColor = .brown
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        coffeeList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
