//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Allows configuration of the supported OAuth Flows.
public class OpenAPIOAuthFlows: Codable {

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
