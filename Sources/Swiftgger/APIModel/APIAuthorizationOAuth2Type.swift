//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/**
    Kind of OAuth2 authorizations.

    - implicit: Configuration for the OAuth Implicit flow.
    - password: Configuration for the OAuth Resource Owner Password flow.
    - clientCredentials: Configuration for the OAuth Client Credentials flow. Previously called application in OpenAPI 2.0.
    - authorizationCode: Configuration for the OAuth Authorization Code flow. Previously called accessCode in OpenAPI 2.0.
 */
public enum APIAuthorizationOAuth2Type {
    case implicit(APIAuthorizationFlow)
    case password(APIAuthorizationFlow)
    case clientCredentials(APIAuthorizationFlow)
    case authorizationCode(APIAuthorizationFlow)
}
