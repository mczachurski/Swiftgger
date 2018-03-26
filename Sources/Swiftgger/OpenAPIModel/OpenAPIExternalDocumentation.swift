//
//  OpenAPIExternalDocumentation.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Allows referencing an external resource for extended documentation.
public class OpenAPIExternalDocumentation: Encodable {

    public private(set) var url: String
    public private(set) var description: String?

    init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
