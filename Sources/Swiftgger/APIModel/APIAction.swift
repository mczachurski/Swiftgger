//
//  APIAction.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class APIAction {
    var method: APIHttpMethod
    var route: String
    var summary: String
    var description: String
    var parameters: [APIParameter]?
    var request: APIRequest?
    var responses: [APIResponse]?
    var authorization: Bool = false

    init(
        method: APIHttpMethod,
        route: String,
        summary: String,
        description: String,
        parameters: [APIParameter]? = nil,
        request: APIRequest? = nil,
        responses: [APIResponse]? = nil,
        authorization: Bool = false
    ) {
        self.method = method
        self.route = route
        self.summary = summary
        self.description = description
        self.parameters = parameters
        self.request = request
        self.responses = responses
        self.authorization = authorization
    }
}
