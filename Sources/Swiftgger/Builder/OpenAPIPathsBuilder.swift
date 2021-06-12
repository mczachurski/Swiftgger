//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Builder of `paths` part of OpenAPI.
class OpenAPIPathsBuilder {
    let controllers: [APIController]
    let authorizations: [APIAuthorizationType]?
    let objects: [APIObject]

    init(controllers: [APIController], authorizations: [APIAuthorizationType]?, objects: [APIObject]) {
        self.controllers = controllers
        self.authorizations = authorizations
        self.objects = objects
    }

    func built() -> [String: OpenAPIPathItem] {

        var paths: [String: OpenAPIPathItem] = [:]
        for controller in controllers {
            for action in controller.actions {

                let openAPIOperationBuilder = OpenAPIOperationBuilder(controllerName: controller.name,
                                                                    action: action,
                                                                    authorizations: self.authorizations,
                                                                    objects: self.objects)
                let openAPIOperation = openAPIOperationBuilder.built()

                if let pathItem = paths[action.route] {
                    pathItem.addOperation(method: action.method, operation: openAPIOperation)
                } else {
                    let pathItem = OpenAPIPathItem()
                    pathItem.addOperation(method: action.method, operation: openAPIOperation)

                    paths[action.route] = pathItem
                }
            }
        }

        return paths
    }
}
