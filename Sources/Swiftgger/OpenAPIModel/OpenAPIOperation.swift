//
//  OpenAPIOperation.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/// Describes a single API operation on a path.
public class OpenAPIOperation: Codable {

    public private(set) var summary: String?
    public private(set) var description: String?
    public private(set) var tags: [String]?
    public private(set) var externalDocs: OpenAPIExample?
    public private(set) var operationId: String?
    public private(set) var parameters: [OpenAPIParameter]?
    public private(set) var requestBody: OpenAPIRequestBody?
    public private(set) var responses: [String: OpenAPIResponse]?
    public private(set) var callbacks: [String: [String: OpenAPIPathItem]]?
    public private(set) var deprecated: Bool = false
    public private(set) var security: [[String: [String]]]?
    public private(set) var servers: [OpenAPIServer]?

    init(
        summary: String? = nil,
        description: String? = nil,
        tags: [String]? = nil,
        externalDocs: OpenAPIExample? = nil,
        operationId: String? = nil,
        parameters: [OpenAPIParameter]? = nil,
        requestBody: OpenAPIRequestBody? = nil,
        responses: [String: OpenAPIResponse]? = nil,
        callbacks: [String: [String: OpenAPIPathItem]]? = nil,
        deprecated: Bool = false,
        security: [[String: [String]]]? = nil,
        servers: [OpenAPIServer]? = nil
    ) {
        self.summary = summary
        self.description = description
        self.tags = tags
        self.externalDocs = externalDocs
        self.operationId = operationId
        self.parameters = parameters
        self.requestBody = requestBody
        self.responses = responses
        self.callbacks = callbacks
        self.deprecated = deprecated
        self.security = security
        self.servers = servers
    }
}
