//
//  OpenAPIPathsBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder of `paths` part of OpenAPI.
class OpenAPIPathsBuilder {
    let controllers: [APIController]
    let authorizations: [APIAuthorizationType]?
    let objects: [APIObject]
    let headers: [APIHeader]?

    init(controllers: [APIController], authorizations: [APIAuthorizationType]?, objects: [APIObject], headers: [APIHeader]?) {
        self.controllers = controllers
        self.authorizations = authorizations
        self.objects = objects
        self.headers = headers
    }

    func built() -> [String: OpenAPIPathItem] {

        var paths: [String: OpenAPIPathItem] = [:]
        for controller in controllers {
            for action in controller.actions {

                let openAPIOperationBuilder = OpenAPIOperationBuilder(controllerName: controller.name,
                                                                    action: action,
                                                                    authorizations: self.authorizations,
                                                                    objects: self.objects, headers: self.headers)
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
