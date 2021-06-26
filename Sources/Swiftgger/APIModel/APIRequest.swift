//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about HTTP request.
public class APIRequest {
    var type: APIBodyType?
    var description: String?
    var contentType: String?

    public init(type: APIBodyType? = nil, description: String? = nil, contentType: String? = nil) {
        self.type = type
        self.description = description
        self.contentType = contentType
    }
}
