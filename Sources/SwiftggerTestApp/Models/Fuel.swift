//
//  Fuel.swift
//  SwiftggerTestApp
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

struct Fuel {
    var level: Int
    var type: String
    var productionDate: Date
    var parameters: [String]
    
    init(level: Int, type: String, productionDate: Date, parameters: [String]) {
        self.level = level
        self.type = type
        self.productionDate = productionDate
        self.parameters = parameters
    }
}
