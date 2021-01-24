//
//  Vehicle.swift
//  SwiftggerApp
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

class Vehicle {
    var name: String
    var age: Int?
    var fuels: [Fuel]?

    init(name: String, age: Int, fuels: [Fuel]? = nil) {
        self.name = name
        self.age = age
        self.fuels = fuels
    }
}
