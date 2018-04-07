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
}
