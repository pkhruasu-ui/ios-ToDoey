//
//  Item.swift
//  Todoey
//
//  Created by Khruasuwan, Prajak(AWF) on 4/20/18.
//  Copyright © 2018 Khruasuwan, Prajak(AWF). All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
    init() {        
    }
}
