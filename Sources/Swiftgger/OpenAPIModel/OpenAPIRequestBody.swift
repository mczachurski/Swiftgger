//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Describes a single request body.
public class OpenAPIRequestBody: Codable {

    public private(set) var ref: String?
    public private(set) var description: String?
    public private(set) var content: [String: OpenAPIMediaType]?
    public private(set) var required: Bool = false

    init(ref: String) {
        self.ref = ref
    }

    init(description: String? = nil, content: [String: OpenAPIMediaType]? = nil, required: Bool = false) {
        self.description = description
        self.content = content
        self.required = required
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case description
        case content
        case required
    }
}
