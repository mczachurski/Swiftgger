//
//  OpenAPISchema.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation
import AnyCodable

/// The Schema Object allows the definition of input and output data types.
public class OpenAPISchema: Codable {

    public private(set) var ref: String?
    public private(set) var type: String?
    public private(set) var format: String?
    public private(set) var items: OpenAPISchema?
    public private(set) var required: [String]?
    public private(set) var properties: [String: OpenAPISchema]?
    public private(set) var example: AnyCodable?
    public private(set) var additionalProperties: OpenAPISchema?
    
    init(ref: String) {
        self.ref = ref
    }

    init(type: String? = nil,
         format: String? = nil,
         items: OpenAPISchema? = nil,
         required: [String]? = nil,
         properties: [(name: String, type: OpenAPISchema)]? = nil,
         example: AnyCodable? = nil,
         additionalProperties: OpenAPISchema? = nil
    ) {
        self.type = type
        self.format = format
        self.items = items
        self.required = required
        self.example = example
        self.additionalProperties = additionalProperties

        if let typeProperies = properties {
            self.properties = [:]
            for property in typeProperies {
                self.properties![property.name] = property.type
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type
        case format
        case items
        case required
        case properties
        case example
        case additionalProperties
    }
}
