//
//  Item.swift
//  Todoey
//
//  Created by Enes Ozcan on 17.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//
import RealmSwift
import Foundation
class Item : Object{
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dataCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
