//
//  Location.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
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
