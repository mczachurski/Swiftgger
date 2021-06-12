//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about HTTP request.
public class APIRequest {
    var type: APIResponseType?
    var description: String?
    var contentType: String?

    public init(type: APIResponseType? = nil, description: String? = nil, contentType: String? = nil) {
        self.type = type
        self.description = description
        self.contentType = contentType
    }
}
