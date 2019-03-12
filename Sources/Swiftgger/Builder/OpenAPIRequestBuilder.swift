//
//  OpenAPIRequestBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Builder for requests information stored in `paths` part of OpenAPI.
class OpenAPIRequestBuilder {

    let request: APIRequest?
    let customSchemaNames: [String: String]

    init(request: APIRequest?, customSchemaNames: [String: String]) {
        self.request = request
        self.customSchemaNames = customSchemaNames
    }

    func built() -> OpenAPIRequestBody? {

        guard let apiRequest = request, let objectRequest = apiRequest.object else {
            return nil
        }

        let objectTypeReference = self.objectReference(for: objectRequest)
        let mediaType = OpenAPIMediaType(schema: OpenAPISchema(ref: objectTypeReference))

        let contentType = apiRequest.contentType ?? "application/json"
        let requestBody = OpenAPIRequestBody(description: apiRequest.description, content: [contentType: mediaType])

        return requestBody
    }

    func objectReference(for type: Any.Type) -> String {
        var mirrorObjectType = String(describing: type)
        mirrorObjectType = customSchemaNames[mirrorObjectType] ?? mirrorObjectType
        let objectTypeReference = "#/components/schemas/\(mirrorObjectType)"
        return objectTypeReference
    }
}
