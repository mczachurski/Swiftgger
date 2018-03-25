//
//  OpenAPIPathsBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class OpenAPIPathsBuilder {
    let controllers: [APIController]
    let authorizations: [APIAuthorizationType]?

    init(controllers: [APIController], authorizations: [APIAuthorizationType]?) {
        self.controllers = controllers
        self.authorizations = authorizations
    }

    func build() -> [String: OpenAPIPathItem] {

        var paths: [String: OpenAPIPathItem] = [:]
        for controller in controllers {
            for action in controller.actions {

                let openAPIOperationBuilder = OpenAPIOperationBuilder(controllerName: controller.name, action: action, authorizations: self.authorizations)
                let openAPIOperation = openAPIOperationBuilder.build()

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
