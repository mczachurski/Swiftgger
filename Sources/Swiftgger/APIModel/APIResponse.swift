//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about HTTP response.
public class APIResponse {
    var code: String
    var description: String
    var type: APIBodyType?
    var contentType: String?

    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }

    public init(code: String, description: String, type: APIBodyType?, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.type = type
        self.contentType = contentType
    }
}
