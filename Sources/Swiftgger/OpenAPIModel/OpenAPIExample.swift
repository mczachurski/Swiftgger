//
//  OpenAPIExample.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Object with example description.
class OpenAPIExample: Encodable {

    public private(set) var ref: String?
    public private(set) var summary: String?
    public private(set) var description: String?
    public private(set) var value: Any?
    public private(set) var externalValue: String?

    init(ref: String) {
        self.ref = ref
    }

    init(summary: String? = nil, description: String? = nil, value: Any? = nil, externalValue: String? = nil) {
        self.summary = summary
        self.description = description
        self.value = value
        self.externalValue = externalValue
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case summary
        case description
        case value
        case externalValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if self.ref != nil {
            try container.encode(ref, forKey: .ref)
        }

        try container.encode(summary, forKey: .summary)
        try container.encode(description, forKey: .description)
        try container.encode(value, forKey: .value)
        try container.encode(externalValue, forKey: .externalValue)
    }
}
