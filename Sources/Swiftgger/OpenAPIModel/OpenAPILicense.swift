//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about license for the exposed API.
public class OpenAPILicense: Codable {

    public private(set) var name: String
    public private(set) var url: URL?

    init(name: String, url: URL? = nil) {
        self.name = name
        self.url = url
    }
}
