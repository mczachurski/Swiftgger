//
//  OpenAPISecuritySchemasBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for security information stored in `components/securitySchemas` part of OpenAPI.
class OpenAPISecuritySchemasBuilder {

    let authorizations: [APIAuthorizationType]?
    let headers: [APIHeader]?
    let authorization: Bool

    init(authorization: Bool, authorizations: [APIAuthorizationType]?, headers: [APIHeader]?) {
        self.authorization = authorization
        self.authorizations = authorizations
        self.headers = headers
    }

    func built() -> [[String: [String]]]? {

        var securitySchemas: [[String: [String]]]?

        if self.authorization && self.authorizations != nil {
            securitySchemas = []

            for authorization in self.authorizations! {
                switch authorization {
                case .basic(description: _):
                    var securityDict: [String: [String]] = [:]
                    securityDict["auth_basic"] = []
                    securitySchemas!.append(securityDict)
                case .jwt(description: _):
                    var securityDict: [String: [String]] = [:]
                    securityDict["auth_jwt"] = []
                    securitySchemas!.append(securityDict)
                case .bearer(description: _):
                    var securityDict: [String: [String]] = [:]
                    securityDict["auth_bearer"] = []
                    securitySchemas!.append(securityDict)
                case .anonymous:
                    break
                }
            }
        }

        if let headers = self.headers {
            if securitySchemas == nil {
                securitySchemas = []
            }
            for header in headers {
                var securityDict: [String: [String]] = [:]
                securityDict[header.scheme] = [header.value]
                securitySchemas!.append(securityDict)
            }
        }

        return securitySchemas
    }
}
