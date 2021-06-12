//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Link to external documentation.
public class APILink {

    var url: String
    var description: String?

    public init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
