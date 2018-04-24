//
//  Item.swift
//  Todoey
//
//  Created by Khruasuwan, Prajak(AWF) on 4/24/18.
//  Copyright © 2018 Khruasuwan, Prajak(AWF). All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
                //                                 parent                   parent's property
}
