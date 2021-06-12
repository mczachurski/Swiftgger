//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// An object representing a Server (address).
public class OpenAPIServer: Codable {

    public private(set) var url: String
    public private(set) var description: String?
    public private(set) var variables: [String: OpenAPIServerVariable]?

    init(url: String, description: String? = nil, variables: [String: OpenAPIServerVariable]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}
