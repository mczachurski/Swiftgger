//
//  OpenAPIResponsesBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for response information stored in `paths` part of OpenAPI.
class OpenAPIResponsesBuilder {

    let responses: [APIResponse]?
    let objects: [APIObject]

    init(responses: [APIResponse]?, objects: [APIObject]) {
        self.responses = responses
        self.objects = objects
    }

    func built() -> [String: OpenAPIResponse]? {

        guard let apiResponses = responses else {
            return nil
        }

        var openAPIResponses: [String: OpenAPIResponse] = [:]

        for apiResponse in apiResponses {

            var apiResponseObject: Any.Type? = nil
            var isArray: Bool = false

            if apiResponse.object != nil {
                apiResponseObject = apiResponse.object
            } else if apiResponse.array != nil {
                isArray = true
                apiResponseObject = apiResponse.array
            }

            if apiResponseObject != nil {

                let contentType = apiResponse.contentType ?? "application/json"

                let openAPIMediaTypeBuilder = OpenAPIMediaTypeBuilder(objects: objects, for: apiResponseObject!, isArray: isArray)
                let mediaType = openAPIMediaTypeBuilder.built()

                let openAPIResponse = OpenAPIResponse(
                    description: apiResponse.description,
                    content: [contentType: mediaType]
                )

                openAPIResponses[apiResponse.code] = openAPIResponse
            } else {
                let openAPIResponse = OpenAPIResponse(description: apiResponse.description)
                openAPIResponses[apiResponse.code] = openAPIResponse
            }
        }

        return openAPIResponses
    }
}
