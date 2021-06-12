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
            if let apiResponseType = apiResponse.type {
                let contentType = apiResponse.contentType ?? "application/json"
                let openAPIMediaTypeBuilder = OpenAPIMediaTypeBuilder(objects: objects, for: apiResponseType)
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
