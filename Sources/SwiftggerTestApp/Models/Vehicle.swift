//
//  Vehicle.swift
//  SwiftggerTestApp
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

class Vehicle {
    var name: String
    var age: Int?
    var fuels: [Fuel]?
    var currentFuel: Fuel? = nil
    var hasEngine: Bool?
    var tags: [String: String]?
    var dictionary: [String: Fuel]?

    init(name: String,
         age: Int,
         fuels: [Fuel]? = nil,
         currentFuel: Fuel? = nil,
         hasEngine: Bool? = nil,
         tags: [String: String]? = nil,
         dictionary: [String: Fuel]? = nil
    ) {
        self.name = name
        self.age = age
        self.fuels = fuels
        self.currentFuel = currentFuel
        self.hasEngine = hasEngine
        self.tags = tags
        self.dictionary = dictionary
    }
}
