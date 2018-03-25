//
//  OpenAPIOperationBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

class OpenAPIOperationBuilder {

    let controllerName: String
    let action: APIAction
    let authorizations: [APIAuthorizationType]?

    init(controllerName: String, action: APIAction, authorizations: [APIAuthorizationType]?) {
        self.controllerName = controllerName
        self.action = action
        self.authorizations = authorizations
    }

    func build() -> OpenAPIOperation {

        let openAPIParametersBuilder = OpenAPIParametersBuilder(parameters: action.parameters)
        let apiParameters = openAPIParametersBuilder.build()

        let openAPIRequestBuilder = OpenAPIRequestBuilder(request: action.request)
        let requestBody = openAPIRequestBuilder.build()

        let openAPIResponsesBuilder = OpenAPIResponsesBuilder(responses: action.responses)
        let openAPIResponses = openAPIResponsesBuilder.build()

        let openAPISecuritySchemasBuilder = OpenAPISecuritySchemasBuilder(authorization: action.authorization, authorizations: self.authorizations)
        let securitySchemas = openAPISecuritySchemasBuilder.build()

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
