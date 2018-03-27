//
//  OpenAPIInfo.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The object provides metadata about the API. The metadata MAY be used by the clients if needed,
// and MAY be presented in editing or documentation generation tools for convenience.
public class OpenAPIInfo: Encodable {

    public private(set) var title: String
    public private(set) var version: String
    public private(set) var description: String?
    public private(set) var termsOfService: String?
    public private(set) var contact: OpenAPIContact?
    public private(set) var license: OpenAPILicense?

    init(
        title: String,
        version: String,
        description: String? = nil,
        termsOfService: String? = nil,
        contact: OpenAPIContact? = nil,
        license: OpenAPILicense? = nil
    ) {
        self.title = title
        self.version = version
        self.description = description
        self.termsOfService = termsOfService
        self.contact = contact
        self.license = license
    }
}
