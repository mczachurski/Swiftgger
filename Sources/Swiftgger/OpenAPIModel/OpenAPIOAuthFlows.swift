//
//  OpenAPIOAuthFlows.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/// Allows configuration of the supported OAuth Flows.
public class OpenAPIOAuthFlows: Encodable {

    public private(set) var implicit: OpenAPIOAuthFlow?
    public private(set) var password: OpenAPIOAuthFlow?
    public private(set) var clientCredentials: OpenAPIOAuthFlow?
    public private(set) var authorizationCode: OpenAPIOAuthFlow?

    init(
        implicit: OpenAPIOAuthFlow? = nil,
        password: OpenAPIOAuthFlow? = nil,
        clientCredentials: OpenAPIOAuthFlow? = nil,
        authorizationCode: OpenAPIOAuthFlow? = nil
    ) {
        self.implicit = implicit
        self.password = password
        self.clientCredentials = clientCredentials
        self.authorizationCode = authorizationCode
    }
}
