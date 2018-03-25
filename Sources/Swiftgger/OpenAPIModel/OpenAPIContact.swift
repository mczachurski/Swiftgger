//
//  OpenAPIContact.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Contact information for the exposed API.
class OpenAPIContact: Encodable {
    public private(set) var name: String?
    public private(set) var url: URL?
    public private(set) var email: String?

    init(
        name: String?,
        email: String? = nil,
        url: URL? = nil
    ) {
        self.name = name
        self.email = email
        self.url = url
    }
}
