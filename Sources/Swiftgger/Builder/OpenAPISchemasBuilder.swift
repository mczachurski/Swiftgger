//
//  OpenAPISchemasBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder for object information stored in `components/schemas` part of OpenAPI.
class OpenAPISchemasBuilder {

    let objects: [APIObject]

    init(objects: [APIObject]) {
        self.objects = objects
    }

    func built() -> [String: OpenAPISchema] {

        var schemas: [String: OpenAPISchema] = [:]
        for object in self.objects {
            add(object: object.object, withCustomName: object.customName, toSchemas: &schemas)
        }

        return schemas
    }

  private func add(object: Any, withCustomName customName: String?, toSchemas schemas: inout [String: OpenAPISchema]) {
        let requestMirror: Mirror = Mirror(reflecting: object)
        let mirrorObjectType = customName ?? String(describing: requestMirror.subjectType)

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
            let unwrapped = unwrap(property.value)
            let dataType = makeAPIDataType(fromSwiftValue: unwrapped)
            let example = String(describing: unwrapped)
            let objectProperty = OpenAPIObjectProperty(type: dataType.type, format: dataType.format, example: example)
            array.append((name: property.label ?? "", type: objectProperty))
        }

        return array
    }

    /// Infer OpenAPI Data Type from Swift value type
    /// (nested types or collections not supported at the moment)
    ///
    /// - Parameter value: Swift property value to analyze
    /// - Returns: Most appropriate OpenAPI Data Type
    private func makeAPIDataType(fromSwiftValue value: Any) -> APIDataType {
        switch value {
        case is Int32:
            return .int32
        case is Int:
            return .int64
        case is Float:
            return .float
        case is Double:
            return .double
        case is Bool:
            return .boolean
        case is Date:
            return .dateTime
        case is String:
            return .string
        default:
            let className = String(describing: value)
            if let className = className.components(separatedBy: ".").last {
                return APIDataType(type: className, format: nil)
            }
            return APIDataType(type: className, format: nil)
        }
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
