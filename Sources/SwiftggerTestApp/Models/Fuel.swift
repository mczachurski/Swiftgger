//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
