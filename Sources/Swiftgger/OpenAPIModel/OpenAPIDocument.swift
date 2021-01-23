//
//  OpenAPIDocument.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation

/// This is the root document object of the OpenAPI document.
public class OpenAPIDocument: Codable {
    public private(set) var openapi = "3.0.1"

    public private(set) var info: OpenAPIInfo
    public private(set) var paths: [String: OpenAPIPathItem]
    public private(set) var servers: [OpenAPIServer]?
    public private(set) var tags: [OpenAPITag]?
    public private(set) var components: OpenAPIComponents?
    public private(set) var security: [String: [String]]?
    public private(set) var externalDocs: OpenAPIExternalDocumentation?

    init(
        info: OpenAPIInfo,
        paths: [String: OpenAPIPathItem],
        servers: [OpenAPIServer]? = nil,
        tags: [OpenAPITag]? = nil,
        components: OpenAPIComponents? = nil,
        security: [String: [String]]? = nil,
        externalDocs: OpenAPIExternalDocumentation? = nil
    ) {
        self.info = info
        self.paths = paths
        self.servers = servers
        self.tags = tags
        self.components = components
        self.security = security
        self.externalDocs = externalDocs
    }
}
