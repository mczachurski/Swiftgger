//
//  OpenAPITagsBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder for general information about controllers stored in `tags` part of OpenAPI.
class OpenAPITagsBuilder {

    let controllers: [APIController]

    init(controllers: [APIController]) {
        self.controllers = controllers
    }

    func built() -> [OpenAPITag] {

        var tags: [OpenAPITag] = []
        for controller in controllers {

            var openAPIExternalDocumentation: OpenAPIExternalDocumentation?
            if let externalLink = controller.link {
                openAPIExternalDocumentation = OpenAPIExternalDocumentation(
                    url: externalLink.url,
                    description: externalLink.description
                )
            }

            let tag = OpenAPITag(
                name: controller.name,
                description: controller.description,
                externalDocs: openAPIExternalDocumentation
            )

            tags.append(tag)
        }

        return tags
    }
}
