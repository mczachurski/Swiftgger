//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// A metadata object that allows for more fine-tuned XML model definitions.
public class OpenAPIXML: Codable {

    public private(set) var name: String?
    public private(set) var namespace: String?
    public private(set) var prefix: String?
    public private(set) var attribute: Bool = false
    public private(set) var wrapped: Bool = false

    init(name: String? = nil, namespace: String? = nil, prefix: String? = nil, attribute: Bool = false, wrapped: Bool = false) {
        self.name = name
        self.namespace = namespace
        self.prefix = prefix
        self.attribute = attribute
        self.wrapped = wrapped
    }
}
