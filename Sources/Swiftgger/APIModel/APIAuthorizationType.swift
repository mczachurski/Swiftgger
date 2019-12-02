//
//  APIAuthorizationType.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/**
    Kind of authorization.

    - anonymous: Access without any authorization.
    - basic: Basic authorization.
    - jwt: Bearer (JWT token) authorization.
 */
public enum APIAuthorizationType {
    case anonymous
    case basic(description: String)
    case jwt(description: String)
    case bearer(description: String)
}

public struct APIHeader {
    let scheme: String
    let value: String
    let description: String?

    public init(scheme: String, value: String, description: String?) {
        self.scheme = scheme
        self.value = value
        self.description = description
    }
}
