//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Allows referencing an external resource for extended documentation.
public class OpenAPIExternalDocumentation: Codable {

    public private(set) var url: String
    public private(set) var description: String?

    init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
