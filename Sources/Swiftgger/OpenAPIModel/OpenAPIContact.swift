//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Contact information for the exposed API.
public class OpenAPIContact: Codable {
    public private(set) var name: String?
    public private(set) var url: URL?
    public private(set) var email: String?

    init(
        name: String?,
        email: String? = nil,
        url: URL? = nil
    ) {
        self.name = name
        self.email = email
        self.url = url
    }
}
