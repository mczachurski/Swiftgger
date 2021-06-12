//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Builder for security information for each HTTP action.
class OpenAPISecurityActionsBuilder {
    
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
                
                var authorizationName: String?
                
                switch authorization {
                case .basic(description: _):
                    authorizationName = "auth_basic"
                case .jwt(description: _):
                    authorizationName = "auth_jwt"
                case .apiKey:
                    authorizationName = "api_key"
                case .oauth2(description: _, flows: _):
                    authorizationName = "oauth2"
                case .openId(description: _, openIdConnectUrl: _):
                    authorizationName = "openId"
                case .anonymous:
                    break
                }
                
                if let authorizationName = authorizationName {
                    var securityDict: [String: [String]] = [:]
                    securityDict[authorizationName] = []
                    securitySchemas!.append(securityDict)
                }
            }
        }
        
        return securitySchemas
    }
}
