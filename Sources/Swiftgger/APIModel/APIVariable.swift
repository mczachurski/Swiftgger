//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Variables used in request parameters.
public class APIVariable {

    var name: String
    var defaultValue: String
    var enumValues: [String]?
    var description: String?

    public init(name: String, defaultValue: String, enumValues: [String]? = nil, description: String? = nil) {
        self.name = name
        self.defaultValue = defaultValue
        self.enumValues = enumValues
        self.description = description
    }
}
