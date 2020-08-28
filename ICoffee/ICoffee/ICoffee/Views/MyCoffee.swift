//
//  MyCoffee.swift
//  ICoffee
//
//  Created by student on 13/06/2020.
//  Copyright © 2020 student. All rights reserved.
//

import Foundation
import UIKit

class MyCoffee {
    
    var name: String
    var note: String
    var urlPicture: String
    var urlToBuy: String
    
    init(name: String, note: String, urlPicture: String, urlToBuy: String){
        self.name = name
        self.note = note
        self.urlPicture = urlPicture
        self.urlToBuy = urlToBuy
    }
    
}
