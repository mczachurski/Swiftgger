//
//  OpenAPIMediaType.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/// Each Media Type Object provides schema and examples for the media type identified by its key.
public class OpenAPIMediaType: Encodable {

    public private(set) var ref: String?
    public private(set) var schema: OpenAPISchema?
    public private(set) var example: String?
    public private(set) var examples: [String: OpenAPIExample]?
    public private(set) var encoding: [String: OpenAPIEncoding]?

    init(ref: String) {
        self.ref = ref
    }

    init(schema: OpenAPISchema? = nil, example: String? = nil, examples: [String: OpenAPIExample]? = nil, encoding: [String: OpenAPIEncoding]? = nil) {
        self.schema = schema
        self.example = example
        self.examples = examples
        self.encoding = encoding
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case schema
        case example
        case examples
        case encoding
    }
}
