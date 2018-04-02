//
//  OpenAPIResponsesBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

class OpenAPIResponsesBuilder {

    let responses: [APIResponse]?

    init(responses: [APIResponse]?) {
        self.responses = responses
    }

    func build() -> [String: OpenAPIResponse]? {

        guard let apiResponses = responses else {
            return nil
        }

        var openAPIResponses: [String: OpenAPIResponse] = [:]

        for apiResponse in apiResponses {

            var objectTypeReference: String? = nil
            var isArray: Bool = false

            if let apiResponseObject = apiResponse.object {
                objectTypeReference = self.objectReference(for: apiResponseObject)
            }

            if let apiResponseArray = apiResponse.array {
                isArray = true
                objectTypeReference = self.objectReference(for: apiResponseArray)
            }

            if objectTypeReference != nil {

                var openAPISchema: OpenAPISchema?
                if isArray {
                    let objectInArraySchema = OpenAPISchema(ref: objectTypeReference!)
                    openAPISchema = OpenAPISchema(type: "array", items: objectInArraySchema)
                } else {
                    openAPISchema = OpenAPISchema(ref: objectTypeReference!)
                }

                let contentType = apiResponse.contentType ?? "application/json"
                let openAPIResponseSchema = OpenAPIMediaType(schema: openAPISchema)

                let openAPIResponse = OpenAPIResponse(
                    description: apiResponse.description,
                    content: [contentType: openAPIResponseSchema]
                )

                openAPIResponses[apiResponse.code] = openAPIResponse
            } else {
                let openAPIResponse = OpenAPIResponse(description: apiResponse.description)
                openAPIResponses[apiResponse.code] = openAPIResponse
            }
        }

        return openAPIResponses
    }

    func objectReference(for type: AnyClass) -> String {
        let mirrorObjectType = String(describing: type)
        let objectTypeReference = "#/components/schemas/\(mirrorObjectType)"
        return objectTypeReference
    }
}
