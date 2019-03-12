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
    let customSchemaNames: [String: String]

    init(controllerName: String, action: APIAction, authorizations: [APIAuthorizationType]?, customSchemaNames: [String: String]) {
        self.controllerName = controllerName
        self.action = action
        self.authorizations = authorizations
        self.customSchemaNames = customSchemaNames
    }

    func built() -> OpenAPIOperation {

        let openAPIParametersBuilder = OpenAPIParametersBuilder(parameters: action.parameters)
        let apiParameters = openAPIParametersBuilder.built()

        let openAPIRequestBuilder = OpenAPIRequestBuilder(request: action.request, customSchemaNames: customSchemaNames)
        let requestBody = openAPIRequestBuilder.built()

        let openAPIResponsesBuilder = OpenAPIResponsesBuilder(responses: action.responses, customSchemaNames: customSchemaNames)
        let openAPIResponses = openAPIResponsesBuilder.built()

        let openAPISecuritySchemasBuilder = OpenAPISecuritySchemasBuilder(authorization: action.authorization, authorizations: self.authorizations)
        let securitySchemas = openAPISecuritySchemasBuilder.built()

        let openAPIOperation = OpenAPIOperation(
            summary: action.summary,
            description: action.description,
            tags: [controllerName],
            parameters: apiParameters,
            requestBody: requestBody,
            responses: openAPIResponses,
            security: securitySchemas
        )

        return openAPIOperation
    }
}
