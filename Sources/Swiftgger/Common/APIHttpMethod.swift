//
//  APIHttpMethod.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Set of request methods to indicate the desired action to be performed for a given resource.
public enum APIHttpMethod {
    case options
    case get
    case head
    case post
    case patch
    case put
    case delete
    case trace
    case connect

    public static var allMethods: [APIHttpMethod] {
        return [.options, .get, .head, .post, .patch, .put, .delete, .trace, .connect]
    }
}
