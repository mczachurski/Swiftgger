//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
                schema: OpenAPISchema(type: apiParameter.dataType.type, format: apiParameter.dataType.format)
            )

            openApiParameters.append(openAPIParameter)
        }

        return openApiParameters
    }
}
