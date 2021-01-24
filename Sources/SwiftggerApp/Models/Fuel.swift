//
//  Fuel.swift
//  SwiftggerApp
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

struct Fuel {
    var level: Int
    var type: String
    
    init(level: Int, type: String) {
        self.level = level
        self.type = type
    }
}
