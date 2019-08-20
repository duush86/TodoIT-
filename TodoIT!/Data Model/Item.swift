//
//  Item.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/19/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
