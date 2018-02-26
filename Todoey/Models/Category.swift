//
//  Category.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 26/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backGroundColor: String = ""
    let items = List<Item>()
}
