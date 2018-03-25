//
//  OpenAPIRequestBody.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single request body.
class OpenAPIRequestBody: Encodable {

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
