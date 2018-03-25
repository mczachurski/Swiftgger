//
//  OpenAPITag.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Adds metadata to a single tag that is used by the Operation Object.
// It is not mandatory to have a Tag Object per tag defined in the Operation Object instances.
class OpenAPITag: Encodable {

    public private(set) var name: String
    public private(set) var description: String?
    public private(set) var externalDocs: OpenAPIExternalDocumentation?

    init(name: String, description: String? = nil, externalDocs: OpenAPIExternalDocumentation? = nil) {
        self.name = name
        self.description = description
        self.externalDocs = externalDocs
    }
}
