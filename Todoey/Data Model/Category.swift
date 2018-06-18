//
//  Category.swift
//  Todoey
//
//  Created by Enes Ozcan on 17.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
