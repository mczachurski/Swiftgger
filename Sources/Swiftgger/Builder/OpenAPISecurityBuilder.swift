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

    init(authorizations: [APIAuthorizationType]?) {
        self.authorizations = authorizations
    }

    func built() -> [String: OpenAPISecurityScheme] {

        var openAPISecuritySchema: [String: OpenAPISecurityScheme] = [:]

        guard let authorizations = self.authorizations else {
            return openAPISecuritySchema
        }

        for authorization in authorizations {

            switch authorization {
            case .basic(description: let description):
                let basicAuth = OpenAPISecurityScheme(type: "http",
                                                      description: description,
                                                      parameterLocation: .header,
                                                      scheme: "basic")

                openAPISecuritySchema["auth_basic"] = basicAuth
            case .jwt(description: let description):
                let jwtAuth = OpenAPISecurityScheme(type: "http",
                                                    description: description,
                                                    parameterLocation: .header,
                                                    scheme: "bearer",
                                                    bearerFormat: "jwt")
                openAPISecuritySchema["auth_jwt"] = jwtAuth
            case .anonymous:
                break
            }
        }

        return openAPISecuritySchema
    }
}
