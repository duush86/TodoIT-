//
//  File.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/19/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
