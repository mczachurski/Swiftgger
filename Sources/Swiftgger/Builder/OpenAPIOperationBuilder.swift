//
//  OpenAPIOperationBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for information about specific operation which is stored in `paths` part of OpenAPI.
class OpenAPIOperationBuilder {

    let controllerName: String
    let action: APIAction
    let authorizations: [APIAuthorizationType]?
    let objects: [APIObject]
    let headers: [APIHeader]?

    init(controllerName: String, action: APIAction, authorizations: [APIAuthorizationType]?, objects: [APIObject], headers: [APIHeader]?) {
        self.controllerName = controllerName
        self.action = action
        self.authorizations = authorizations
        self.objects = objects
        self.headers = headers
    }

    func built() -> OpenAPIOperation {

        let openAPIParametersBuilder = OpenAPIParametersBuilder(parameters: self.action.parameters)
        let apiParameters = openAPIParametersBuilder.built()

        let openAPIRequestBuilder = OpenAPIRequestBuilder(request: self.action.request, objects: self.objects)
        let requestBody = openAPIRequestBuilder.built()

        let openAPIResponsesBuilder = OpenAPIResponsesBuilder(responses: self.action.responses, objects: self.objects)
        let openAPIResponses = openAPIResponsesBuilder.built()

        let openAPISecuritySchemasBuilder = OpenAPISecuritySchemasBuilder(authorization: self.action.authorization,
                                                                          authorizations: self.authorizations, headers: self.headers)
        let securitySchemas = openAPISecuritySchemasBuilder.built()

        let openAPIOperation = OpenAPIOperation(
            summary: self.action.summary,
            description: self.action.description,
            tags: [self.controllerName],
            parameters: apiParameters,
            requestBody: requestBody,
            responses: openAPIResponses,
            security: securitySchemas
        )

        return openAPIOperation
    }
}
