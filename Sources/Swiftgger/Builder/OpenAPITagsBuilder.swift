//
//  OpenAPITagsBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class OpenAPITagsBuilder {

    let controllers: [APIController]

    init(controllers: [APIController]) {
        self.controllers = controllers
    }

    func build() -> [OpenAPITag] {

        var tags: [OpenAPITag] = []
        for controller in controllers {

            var openAPIExternalDocumentation: OpenAPIExternalDocumentation? = nil
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
