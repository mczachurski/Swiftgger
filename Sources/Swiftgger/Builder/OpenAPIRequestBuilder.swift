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
    let objects: [APIObject]

    init(request: APIRequest?, objects: [APIObject]) {
        self.request = request
        self.objects = objects
    }

    func built() -> OpenAPIRequestBody? {

        guard let apiRequest = request, let apiRequestObject = apiRequest.object else {
            return nil
        }

        let contentType = apiRequest.contentType ?? "application/json"

        let openAPIMediaTypeBuilder = OpenAPIMediaTypeBuilder(objects: objects, for: apiRequestObject)
        let mediaType = openAPIMediaTypeBuilder.built()

        let requestBody = OpenAPIRequestBody(description: apiRequest.description, content: [contentType: mediaType])

        return requestBody
    }
}
