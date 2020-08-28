//
//  addCoffeeControler.swift
//  ICoffee
//
//  Created by student on 19/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseDatabase


class AddCoffeeController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var storage: [MyCoffee] = []
    var coffeeDictionary = [String:[String]]()
    var coffeeSections = [String]()
    var s: Bool = true
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        dataD()
        
    }
    func dataD(){
        let ref=Database.database().reference()
        ref.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0{
                self.storage.removeAll()
                for cc in snapshot.children.allObjects as! [DataSnapshot]{
                    let coffeeO = cc.value as? [String:AnyObject]
                    let cName=coffeeO?["name"]
                    let cUrlP=coffeeO?["urlpicture"]
                    let cUrlB=coffeeO?["urlToBuy"]
                    let cNote=coffeeO?["note"]
                    
                    let obj = MyCoffee(name: (cName as! String), note: (cNote as! String),
                                       urlPicture: (cUrlP as! String), urlToBuy:  (cUrlB as! String))
                    self.storage.append(obj)
                }
                DispatchQueue.main.async {
                    self.printAll()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func printAll(){
        for coffee in self.storage {
            let coffeeID = String(coffee.name.prefix(1))
            if var coffeeValues =  self.coffeeDictionary[coffeeID] {
                coffeeValues.append(String(coffee.name))
                self.coffeeDictionary[coffeeID] = coffeeValues
            } else {
                self.coffeeDictionary[coffeeID] = [String(coffee.name)]
            }
        }
        self.coffeeSections = [String](self.coffeeDictionary.keys)
        self.coffeeSections =  self.coffeeSections.sorted(by: {$0 < $1})
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let listViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.listViewC) as? ListViewController
        
        self.view.window?.rootViewController = listViewC
        self.view.window?.makeKeyAndVisible()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  self.coffeeSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  self.coffeeSections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cID =  self.coffeeSections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAdd", for: indexPath)
        
        if let cValues =  self.coffeeDictionary[cID]{
            cell.textLabel?.textColor = .brown
            cell.textLabel!.text = cValues[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cID = self.coffeeSections[section]
        if let cValues = self.coffeeDictionary[cID]{
            return cValues.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.coffeeSections.count
    }
    
    //picking and moving back on c list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        for c in storage{
            if c.name == cell?.textLabel?.text{
                coffeeList.append(c)
            }
        }
        let listViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.listViewC) as? ListViewController
        
        self.view.window?.rootViewController = listViewC
        self.view.window?.makeKeyAndVisible()
    }
}

