//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
    var keyId: UUID?
    var uuidIds: [UUID]?

    init(name: String,
         age: Int,
         fuels: [Fuel]? = nil,
         currentFuel: Fuel? = nil,
         hasEngine: Bool? = nil,
         tags: [String: String]? = nil,
         dictionary: [String: Fuel]? = nil,
         keyId: UUID? = nil,
         uuidIds: [UUID]? = nil
    ) {
        self.name = name
        self.age = age
        self.fuels = fuels
        self.currentFuel = currentFuel
        self.hasEngine = hasEngine
        self.tags = tags
        self.dictionary = dictionary
        self.keyId = keyId
        self.uuidIds = uuidIds
    }
}
