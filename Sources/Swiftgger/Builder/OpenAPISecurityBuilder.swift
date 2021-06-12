//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Builder for security information stored in `components/securitySchemas` part of OpenAPI.
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
            case .apiKey(description: let description, keyName: let keyName, location: let location):
                let apiKeyAuth = OpenAPISecurityScheme(type: "apiKey",
                                                       description: description,
                                                       name: keyName ?? "X-API-KEY",
                                                       parameterLocation: location ?? .header)
                openAPISecuritySchema["api_key"] = apiKeyAuth
            case .oauth2(description: let description, flows: let flows):
                
                var implicit: OpenAPIOAuthFlow?
                var password: OpenAPIOAuthFlow?
                var clientCredentials: OpenAPIOAuthFlow?
                var authorizationCode: OpenAPIOAuthFlow?

                for flow in flows {
                    switch flow {
                    case .implicit(let implicitFlow):
                        implicit = self.mapToOpenAPIOAuthFlow(from: implicitFlow)
                        break
                    case .password(let passwordFlow):
                        password = self.mapToOpenAPIOAuthFlow(from: passwordFlow)
                        break
                    case .clientCredentials(let clientCredentialsFlow):
                        clientCredentials = self.mapToOpenAPIOAuthFlow(from: clientCredentialsFlow)
                        break
                    case .authorizationCode(let authorizationCodeFlow):
                        authorizationCode = self.mapToOpenAPIOAuthFlow(from: authorizationCodeFlow)
                        break
                    }
                }
                
                let openAPIOAuthFlows = OpenAPIOAuthFlows(implicit: implicit,
                                                          password: password,
                                                          clientCredentials: clientCredentials,
                                                          authorizationCode: authorizationCode)
                
                let oauth2Auth = OpenAPISecurityScheme(type: "oauth2",
                                                       description: description,
                                                       flows: openAPIOAuthFlows)

                openAPISecuritySchema["oauth2"] = oauth2Auth
            case .openId(description: let description, openIdConnectUrl: let openIdConnectUrl):
                let openIdAuth = OpenAPISecurityScheme(type: "openIdConnect",
                                                       description: description,
                                                       openIdConnectUrl: openIdConnectUrl)
                openAPISecuritySchema["openId"] = openIdAuth
                break
            case .anonymous:
                break
            }
        }
        
        return openAPISecuritySchema
    }
    
    private func mapToOpenAPIOAuthFlow(from flow: APIAuthorizationFlow) -> OpenAPIOAuthFlow {
        return OpenAPIOAuthFlow(authorizationUrl: flow.authorizationUrl,
                                tokenUrl: flow.tokenUrl,
                                refreshUrl: flow.refreshUrl,
                                scopes: flow.scopes)
    }
}
