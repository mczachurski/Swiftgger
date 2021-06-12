//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Contact information to API owner.
public class APIContact {

    var name: String?
    var email: String?
    var url: URL?

    public init(name: String? = nil, email: String? = nil, url: URL? = nil) {
        self.name = name
        self.email = email
        self.url = url
    }
}
