//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about API license.
public class APILicense {

    var name: String
    var url: URL?

    public init(name: String, url: URL? = nil) {
        self.name = name
        self.url = url
    }
}
