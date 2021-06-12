//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Configuration details for a supported OAuth Flow.
public class OpenAPIOAuthFlow: Codable {

    public private(set) var authorizationUrl: String?
    public private(set) var tokenUrl: String?
    public private(set) var refreshUrl: String?
    public private(set) var scopes: [String: String]?

    init(
        authorizationUrl: String? = nil,
        tokenUrl: String? = nil,
        refreshUrl: String? = nil,
        scopes: [String: String]? = nil
    ) {
        self.authorizationUrl = authorizationUrl
        self.tokenUrl = tokenUrl
        self.refreshUrl = refreshUrl
        self.scopes = scopes
    }
}
