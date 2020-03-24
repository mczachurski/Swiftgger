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
    let authorization: Bool
    
    init(authorization: Bool, authorizations: [APIAuthorizationType]?) {
        self.authorization = authorization
        self.authorizations = authorizations
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
                case .apiKey:
                    var securityDict: [String: [String]] = [:]
                    securityDict["api_key"] = []
                    securitySchemas!.append(securityDict)
                case .anonymous:
                    break
                }
            }
        }
        
        return securitySchemas
    }
}
