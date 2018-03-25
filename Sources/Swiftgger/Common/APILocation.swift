//
//  Location.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

// Enum with possible parameters locations.
enum APILocation: String, Encodable {
    case query
    case header
    case path
    case cookie
}
