//
//  APIAuthorizationType.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public enum APIAuthorizationType {
    case anonymous
    case basic(description: String)
    case jwt(description: String)
}
