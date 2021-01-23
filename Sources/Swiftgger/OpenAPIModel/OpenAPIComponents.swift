//
//  OpenAPIComponents.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/**
    Holds a set of reusable objects for different aspects of the OAS. All objects defined within
    the components object will have no effect on the API unless they are explicitly referenced
    from properties outside the components object.
 */
public class OpenAPIComponents: Codable {
    public private(set) var schemas: [String: OpenAPISchema]?
    public private(set) var responses: [String: OpenAPIResponse]?
    public private(set) var parameters: [String: OpenAPIParameter]?
    public private(set) var examples: [String: OpenAPIExample]?
    public private(set) var requestBodies: [String: OpenAPIRequestBody]?
    public private(set) var headers: [String: OpenAPIHeader]?
    public private(set) var securitySchemes: [String: OpenAPISecurityScheme]?
    public private(set) var links: [String: OpenAPILink]?
    public private(set) var callbacks: [String: [String: OpenAPIPathItem]]?

    init(
        schemas: [String: OpenAPISchema]? = nil,
        responses: [String: OpenAPIResponse]? = nil,
        parameters: [String: OpenAPIParameter]? = nil,
        examples: [String: OpenAPIExample]? = nil,
        requestBodies: [String: OpenAPIRequestBody]? = nil,
        headers: [String: OpenAPIHeader]? = nil,
        securitySchemes: [String: OpenAPISecurityScheme]? = nil,
        links: [String: OpenAPILink]? = nil,
        callbacks: [String: [String: OpenAPIPathItem]]? = nil
    ) {
        self.schemas = schemas
        self.responses = responses
        self.parameters = parameters
        self.examples = examples
        self.requestBodies = requestBodies
        self.headers = headers
        self.securitySchemes = securitySchemes
        self.links = links
        self.callbacks = callbacks
    }
}
