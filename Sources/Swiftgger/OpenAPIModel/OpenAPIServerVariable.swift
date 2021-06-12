//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// An object representing a Server Variable for server URL template substitution.
public class OpenAPIServerVariable: Codable {

    public private(set) var defaultValue: String
    public private(set) var enumValues: [String]?
    public private(set) var description: String?

    init(defaultValue: String, enumValues: [String]? = nil, description: String? = nil) {
        self.defaultValue = defaultValue
        self.enumValues = enumValues
        self.description = description
    }

    private enum CodingKeys: String, CodingKey {
        case defaultValue = "default"
        case enumValues = "enum"
        case description
    }
}
