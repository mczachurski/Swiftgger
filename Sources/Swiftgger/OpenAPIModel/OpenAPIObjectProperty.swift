//
//  OpenAPIObjectProperty.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 21.03.2018.
//

import Foundation

/// Information about property which exists in schema (input/output) data.
public class OpenAPIObjectProperty: Encodable {

    public private(set) var type: String?
    public private(set) var format: String?
    public private(set) var example: String?
    public private(set) var ref: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case format
        case example
        case ref = "$ref"
    }

    init(type: String?, format: String?, example: String?, ref: String?) {
        self.type = type
        self.format = format
        self.example = example
        self.ref = ref
    }
}
