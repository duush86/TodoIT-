//
//  Item.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/14/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import Foundation

class item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
