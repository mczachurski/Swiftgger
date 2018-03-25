//
//  OpenAPIOAuthFlow.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Configuration details for a supported OAuth Flow.
class OpenAPIOAuthFlow: Encodable {

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
