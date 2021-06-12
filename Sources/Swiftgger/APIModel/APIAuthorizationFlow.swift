//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Configuration details for a supported OAuth Flow.
public class APIAuthorizationFlow {

    var authorizationUrl: String
    var tokenUrl: String
    var refreshUrl: String?
    var scopes: [String: String]

    public init(authorizationUrl: String, tokenUrl: String, scopes: [String: String], refreshUrl: String? = nil) {
        self.authorizationUrl = authorizationUrl
        self.tokenUrl = tokenUrl
        self.scopes = scopes
        self.refreshUrl = refreshUrl
    }
}
