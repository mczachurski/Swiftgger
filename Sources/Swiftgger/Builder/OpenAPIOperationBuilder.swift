//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Builder for information about specific operation which is stored in `paths` part of OpenAPI.
class OpenAPIOperationBuilder {

    let controllerName: String
    let action: APIAction
    let authorizations: [APIAuthorizationType]?
    let objects: [APIObjectProtocol]

    init(controllerName: String, action: APIAction, authorizations: [APIAuthorizationType]?, objects: [APIObjectProtocol]) {
        self.controllerName = controllerName
        self.action = action
        self.authorizations = authorizations
        self.objects = objects
    }

    func built() -> OpenAPIOperation {

        let openAPIParametersBuilder = OpenAPIParametersBuilder(parameters: action.parameters)
        let apiParameters = openAPIParametersBuilder.built()

        let openAPIRequestBuilder = OpenAPIRequestBuilder(request: action.request, objects: objects)
        let requestBody = openAPIRequestBuilder.built()

        let openAPIResponsesBuilder = OpenAPIResponsesBuilder(responses: action.responses, objects: objects)
        let openAPIResponses = openAPIResponsesBuilder.built()

        let openAPISecuritySchemasBuilder = OpenAPISecurityActionsBuilder(authorization: action.authorization,
                                                                         authorizations: authorizations)
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
