//
//  OpenAPIInfoBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for `info` part of OpenAPI.
class OpenAPIInfoBuilder {

    var title: String
    var version: String
    var description: String
    var termsOfService: String?
    let contact: APIContact?
    let license: APILicense?

    init(
        title: String,
        version: String,
        description: String,
        termsOfService: String?,
        contact: APIContact?,
        license: APILicense?
    ) {
        self.title = title
        self.version = version
        self.description = description
        self.termsOfService = termsOfService
        self.contact = contact
        self.license = license
    }

    func built() -> OpenAPIInfo {

        var openAPIContact: OpenAPIContact?
        if let apiContact = self.contact {
            openAPIContact = OpenAPIContact(name: apiContact.name, email: apiContact.email, url: apiContact.url)
        }

        var openAPILicense: OpenAPILicense?
        if let apiLicense = self.license {
            openAPILicense = OpenAPILicense(name: apiLicense.name, url: apiLicense.url)
        }

        let openAPIInfo = OpenAPIInfo(
            title: self.title,
            version: self.version,
            description: self.description,
            termsOfService: self.termsOfService,
            contact: openAPIContact,
            license: openAPILicense
        )

        return openAPIInfo
    }
}
