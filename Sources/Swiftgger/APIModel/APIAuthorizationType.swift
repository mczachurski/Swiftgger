//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/**
    Kind of authorization.

    - anonymous: Access without any authorization.
    - basic: Basic authorization.
    - jwt: Bearer (JWT token) authorization.
    - apiKey: API keys for authorization. An API key is a token that a client provides when making API calls.
    - oauth2: OAuth 2.0 authorization.
    - openId: OpenId Connect authorization.
 */
public enum APIAuthorizationType {
    case anonymous
    case basic(description: String)
    case jwt(description: String)
    case apiKey(description: String, keyName: String? = nil, location: APILocation? = nil)
    case oauth2(description: String, flows: [APIAuthorizationOAuth2Type])
    case openId(description: String, openIdConnectUrl: String)
}
