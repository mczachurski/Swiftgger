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

    init(request: APIRequest?) {
        self.request = request
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
        let mirrorObjectType = String(describing: type)
        let objectTypeReference = "#/components/schemas/\(mirrorObjectType)"
        return objectTypeReference
    }
}
