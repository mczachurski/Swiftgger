//
//  OpenAPIObjectProperty.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 21.03.2018.
//

import Foundation

/// Information about property which exists in schema (input/output) data.
public class OpenAPIObjectProperty: Codable {

    public private(set) var ref: String?
    public private(set) var type: String?
    public private(set) var format: String?
    public private(set) var example: String?
    public private(set) var items: OpenAPISchema?

    init(ref: String) {
        self.ref = ref
    }

    init(items: OpenAPISchema) {
        self.items = items
    }

    init(type: String, format: String?, example: String?) {
        self.type = type
        self.format = format
        self.example = example
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type
        case format
        case example
        case items
    }
}
