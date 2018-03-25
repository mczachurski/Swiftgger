//
//  OpenAPIRequestBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

class OpenAPIRequestBuilder {

    let request: APIRequest?

    init(request: APIRequest?) {
        self.request = request
    }

    func build() -> OpenAPIRequestBody? {

        guard let apiRequest = request, let objectRequest = apiRequest.object else {
            return nil
        }

        var requestBody: OpenAPIRequestBody?

        let requestMirror: Mirror = Mirror(reflecting: objectRequest)
        let mirrorObjectType = String(describing: requestMirror.subjectType)
        let objectTypeReference = "#/components/schemas/\(mirrorObjectType)"

        let mediaType = OpenAPIMediaType(schema: OpenAPISchema(ref: objectTypeReference))

        let contentType = apiRequest.contentType ?? "application/json"
        requestBody = OpenAPIRequestBody(description: apiRequest.description, content: [contentType: mediaType])

        return requestBody
    }
}
