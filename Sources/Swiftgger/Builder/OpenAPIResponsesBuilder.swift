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

            if apiResponse.object != nil {

                var responseObject = apiResponse.object

                if responseObject is [Any] {
                    isArray = true
                    let arrayObject = responseObject! as! [Any] // swiftlint:disable:this force_cast
                    responseObject = arrayObject[0]
                }

                let responseMirror: Mirror = Mirror(reflecting: responseObject!)
                let mirrorObjectType = String(describing: responseMirror.subjectType)
                objectTypeReference = "#/components/schemas/\(mirrorObjectType)"
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
}
