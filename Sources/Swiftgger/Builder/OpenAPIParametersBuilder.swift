//
//  OpenAPIParametersBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for request's parameter which is stored in specific operation (`paths` part of OpenAPI).
class OpenAPIParametersBuilder {

    let parameters: [APIParameter]?

    init(parameters: [APIParameter]?) {
        self.parameters = parameters
    }

    func built() -> [OpenAPIParameter]? {

        guard let apiParameters = parameters else {
            return nil
        }

        var openApiParameters: [OpenAPIParameter] = []

        for apiParameter in apiParameters {
            let openAPIParameter = OpenAPIParameter(
                name: apiParameter.name,
                parameterLocation: apiParameter.parameterLocation,
                description: apiParameter.description,
                required: apiParameter.required,
                deprecated: apiParameter.deprecated,
                allowEmptyValue: apiParameter.allowEmptyValue,
                schema: OpenAPISchema(type: "string")
            )

            openApiParameters.append(openAPIParameter)
        }

        return openApiParameters
    }
}
