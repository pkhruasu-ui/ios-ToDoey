//
//  Category.swift
//  Todoey
//
//  Created by Khruasuwan, Prajak(AWF) on 4/24/18.
//  Copyright © 2018 Khruasuwan, Prajak(AWF). All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // One to Many relationship
}

