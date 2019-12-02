//
//  OpenAPISecuritySchemaBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder for security information for each HTTP action.
class OpenAPISecurityBuilder {

    let authorizations: [APIAuthorizationType]?
    let headers: [APIHeader]?

    init(authorizations: [APIAuthorizationType]?, headers: [APIHeader]?) {
        self.authorizations = authorizations
        self.headers = headers
    }

    func built() -> [String: OpenAPISecurityScheme] {

        var openAPISecuritySchema: [String: OpenAPISecurityScheme] = [:]

        if let headers = self.headers {
            for header in headers {

                let h = OpenAPISecurityScheme(
                    type: "apiKey",
                    description: header.description,
                    name: header.scheme,
                    parameterLocation: .header)
                openAPISecuritySchema[header.scheme] = h

            }
        }

        guard let authorizations = self.authorizations else {
            return openAPISecuritySchema
        }

        for authorization in authorizations {

            switch authorization {
            case .basic(description: let description):
                let basicAuth = OpenAPISecurityScheme(
                    type: "http",
                    description: description,
                    parameterLocation: .header,
                    scheme: "basic")

                openAPISecuritySchema["auth_basic"] = basicAuth
            case .jwt(description: let description):
                let jwtAuth = OpenAPISecurityScheme(
                    type: "http",
                    description: description,
                    parameterLocation: .header,
                    scheme: "bearer",
                    bearerFormat: "jwt")
                openAPISecuritySchema["auth_jwt"] = jwtAuth
            case .anonymous:
                break
            case .bearer(description: let description):
                let bearerAuth = OpenAPISecurityScheme(
                    type: "http",
                    description: description,
                    scheme: "bearer")
                openAPISecuritySchema["auth_bearer"] = bearerAuth
            }
        }
        return openAPISecuritySchema
    }
}
