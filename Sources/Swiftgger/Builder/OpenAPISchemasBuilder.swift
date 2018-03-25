//
//  OpenAPISchemasBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class OpenAPISchemasBuilder {

    let controllers: [APIController]

    init(controllers: [APIController]) {
        self.controllers = controllers
    }

    func build() -> [String: OpenAPISchema] {

        var schemas: [String: OpenAPISchema] = [:]
        for controller in self.controllers {
            for action in controller.actions {
                objectFrom(request: action.request, appendTo: &schemas)
                objectsFrom(responses: action.responses, appendTo: &schemas)
            }
        }

        return schemas
    }

    private func objectFrom(request: APIRequest?, appendTo schemas: inout [String: OpenAPISchema]) {

        guard let requestObject = request?.object else {
            return
        }

        add(object: requestObject, toSchemas: &schemas)
    }

    private func objectsFrom(responses: [APIResponse]?, appendTo schemas: inout [String: OpenAPISchema]) {

        guard let responsesArray = responses else {
            return
        }

        for response in responsesArray {

            guard var responseObject = response.object else {
                continue
            }

            if response.object is [Any] {
                let arrayObject = responseObject as! [Any] // swiftlint:disable:this force_cast
                responseObject = arrayObject[0]
            }

            add(object: responseObject, toSchemas: &schemas)
        }
    }

    private func add(object: Any, toSchemas schemas: inout [String: OpenAPISchema]) {
        let requestMirror: Mirror = Mirror(reflecting: object)
        let mirrorObjectType = String(describing: requestMirror.subjectType)

        if schemas[mirrorObjectType] == nil {
            let required = self.getRequiredProperties(properties: requestMirror.children)
            let properties = self.getAllProperties(properties: requestMirror.children)
            let requestSchema = OpenAPISchema(type: "object", required: required, properties: properties)
            schemas[mirrorObjectType] = requestSchema
        }
    }

    private func getAllProperties(properties: Mirror.Children) -> [(name: String, type: OpenAPIObjectProperty)] {

        var array:  [(name: String, type: OpenAPIObjectProperty)] = []
        for property in properties {
            let someType = type(of: unwrap(property.value))
            let typeName = String(describing: someType)
            let example = String(describing: unwrap(property.value))
            array.append((name: property.label!, type: OpenAPIObjectProperty(type: typeName.lowercased(), example: example)))
        }

        return array
    }

    private func getRequiredProperties(properties: Mirror.Children) -> [String] {
        var array: [String] = []

        for property in properties {
            if !isOptional(property.value) {
                array.append(property.label!)
            }
        }

        return array
    }

    private func unwrap<T>(_ any: T) -> Any {

        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return first.value
    }

    private func isOptional<T>(_ any: T) -> Bool {
        let mirror = Mirror(reflecting: any)
        return mirror.displayStyle == .optional
    }
}
