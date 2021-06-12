//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/**
    Enum with possible parameters locations.

    - query: Parameter in URL query.
    - header: Parameter in request header.
    - path: Parameter in URL path.
    - cookie: Parameter in cookie.
 */
public enum APILocation: String, Codable {
    case query
    case header
    case path
    case cookie
}
