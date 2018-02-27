//
//  Item.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 26/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
