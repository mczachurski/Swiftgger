//
//  OpenAPILink.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The Link object represents a possible design-time link for a response.
// The presence of a link does not guarantee the caller's ability to successfully invoke it,
// rather it provides a known relationship and traversal mechanism between responses and other operations.
class OpenAPILink: Encodable {

    public private(set) var ref: String?
    public private(set) var operationRef: String?
    public private(set) var operationId: String?
    public private(set) var parameters: [String: String]?
    public private(set) var requestBody: String?
    public private(set) var description: String?
    public private(set) var server: OpenAPIServer?

    init(ref: String) {
        self.ref = ref
    }

    init(
        operationRef: String? = nil,
        operationId: String? = nil,
        parameters: [String: String]? = nil,
        requestBody: String? = nil,
        description: String? = nil,
        server: OpenAPIServer?
    ) {
        self.operationRef = operationRef
        self.operationId = operationId
        self.parameters = parameters
        self.requestBody = requestBody
        self.description = description
        self.server = server
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case operationRef
        case operationId
        case parameters
        case requestBody
        case description
        case server
    }
}
