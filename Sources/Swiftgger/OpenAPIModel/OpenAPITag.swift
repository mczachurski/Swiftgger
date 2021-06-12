//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/**
    Adds metadata to a single tag that is used by the Operation Object.
    It is not mandatory to have a Tag Object per tag defined in the Operation Object instances.
 */
public class OpenAPITag: Codable {

    public private(set) var name: String
    public private(set) var description: String?
    public private(set) var externalDocs: OpenAPIExternalDocumentation?

    init(name: String, description: String? = nil, externalDocs: OpenAPIExternalDocumentation? = nil) {
        self.name = name
        self.description = description
        self.externalDocs = externalDocs
    }
}
