//
//  OpenAPISchemasBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation
import AnyCodable

/// Builder for object information stored in `components/schemas` part of OpenAPI.
class OpenAPISchemasBuilder {

    let objects: [APIObject]
    private var nestedObjects: [Any] = []

    init(objects: [APIObject]) {
        self.objects = objects
    }

    func built() -> [String: OpenAPISchema] {

        var schemas: [String: OpenAPISchema] = [:]
        for object in self.objects {
            add(object: object.object, withCustomName: object.customName, toSchemas: &schemas)
        }

        for nestedObject in self.nestedObjects {
            add(object: nestedObject, withCustomName: nil, toSchemas: &schemas)
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

    private func getAllProperties(properties: Mirror.Children) -> [(name: String, type: OpenAPISchema)] {
        var array:  [(name: String, type: OpenAPISchema)] = []
        for property in properties {
            
            // Eventually extract property from property wrapper.
            let unwrappedProperty = self.getWrappedProperty(property: property)
            
            // Append property with correct type to array.
            self.appendProperty(property: unwrappedProperty, array: &array)
        }

        return array
    }
    
    private func appendProperty(property: Mirror.Child, array: inout [(name: String, type: OpenAPISchema)]) {

        // Simple value type (also unwrapped optionals).
        let unwrapped = unwrap(property.value)
        if let dataType = makeAPIDataType(fromSwiftValue: unwrapped) {
            self.append(dataType: dataType, property: property, unwrapped: unwrapped, array: &array)
            return
        }
        
        // Non optional or initialized array (array which contains any data).
        if let items = property.value as? Array<Any> {
            self.append(items: items, property: property, array: &array)
            return
        }
        
        if let items = property.value as? Dictionary<String, Any> {
            self.append(dictionary: items, property: property, array: &array)
            return
        }
        
        // Non optional or initialized object.
        if self.isInitialized(object: unwrapped) {
            self.append(reference: property, array: &array)
            return
        }
        
        // Optional and not initialized object.
        if let typeName = self.getTypeName(from: unwrapped) {
            self.append(typeName: typeName, property: property, array: &array)
            return
        }
        
        // Optional and not initialized arrays.
        if let typeName = self.getArrayTypeName(from: unwrapped) {
            self.append(arrayName: typeName, property: property, array: &array)
            return
        }
    }

    /// Infer OpenAPI Data Type from Swift value type
    /// (nested types or collections not supported at the moment)
    ///
    /// - Parameter value: Swift property value to analyze
    /// - Returns: Most appropriate OpenAPI Data Type
    private func makeAPIDataType(fromSwiftValue value: Any) -> APIDataType? {
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
            return nil
        }
    }

    private func append(dataType: APIDataType,
                        property: Mirror.Child,
                        unwrapped: Any,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        let example = AnyCodable(unwrapped)
        let objectProperty = OpenAPISchema(type: dataType.type, format: dataType.format, example: example)
        array.append((name: property.label ?? "", type: objectProperty))
    }

    private func append(items: Array<Any>,
                        property: Mirror.Child,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        guard let item = items.first else {
            return
        }

        let unwrapped = unwrap(item)
        if let dataType = makeAPIDataType(fromSwiftValue: unwrapped) {
            let openApiSchema = OpenAPISchema(type: dataType.type, format: dataType.format)
            let objectProperty = OpenAPISchema(items: openApiSchema)

            array.append((name: property.label ?? "", type: objectProperty))
        } else {
            let typeName = String(describing: type(of: item))
            let openApiSchema = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
            let objectProperty = OpenAPISchema(items: openApiSchema)

            array.append((name: property.label ?? "", type: objectProperty))
            self.nestedObjects.append(item)
        }
    }
    
    private func append(dictionary: Dictionary<String, Any>,
                        property: Mirror.Child,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        guard let item = dictionary.first else {
            return
        }
        
        let unwrapped = unwrap(item.value)
        if let dataType = makeAPIDataType(fromSwiftValue: unwrapped) {
            let additionalProperties = OpenAPISchema(type: dataType.type, format: dataType.format)
            let objectProperty = OpenAPISchema(type: "object", additionalProperties: additionalProperties)

            array.append((name: property.label ?? "", type: objectProperty))
        } else {
            let typeName = String(describing: type(of: item.value))
            let additionalProperties = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
            let objectProperty = OpenAPISchema(type: "object", additionalProperties: additionalProperties)

            array.append((name: property.label ?? "", type: objectProperty))
            self.nestedObjects.append(item.value)
        }
    }

    private func append(reference: Mirror.Child,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        let unwrapped = unwrap(reference.value)
        let typeName = String(describing: type(of: unwrapped))
        let objectProperty = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
        array.append((name: reference.label ?? "", type: objectProperty))

        self.nestedObjects.append(unwrapped)
    }
    
    private func append(typeName: String,
                        property: Mirror.Child,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {

        let objectProperty = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
        array.append((name: property.label ?? "", type: objectProperty))
    }
    
    private func append(arrayName: String,
                        property: Mirror.Child,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        let openApiSchema = OpenAPISchema(ref: "#/components/schemas/\(arrayName)")
        let objectProperty = OpenAPISchema(items: openApiSchema)
        array.append((name: property.label ?? "", type: objectProperty))
    }

    private func getRequiredProperties(properties: Mirror.Children) -> [String] {
        var array: [String] = []

        for property in properties {
            
            // Eventually extract property from property wrapper.
            let unwrappedProperty = self.getWrappedProperty(property: property)
            
            // Append to list of required non optional properties.
            if !isOptional(unwrappedProperty.value) {
                array.append(unwrappedProperty.label!)
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
    
    private func isInitialized<T>(object any: T) -> Bool {
        let mirror = Mirror(reflecting: any)

        return mirror.displayStyle == .struct
            || mirror.displayStyle == .class
            || mirror.displayStyle == .enum
    }
    
    private func getTypeName(from any: Any) -> String? {
        let typeName = String(describing: type(of: any))
        
        let pattern = "^Optional<(?<type>\\w+)>$"
        return self.match(pattern: pattern, in: typeName)
    }

    private func getArrayTypeName(from any: Any) -> String? {
        let typeName = String(describing: type(of: any))
        
        let pattern = "^Optional<Array<(?<type>\\w+)>>$"
        return self.match(pattern: pattern, in: typeName)
    }
    
    private func getWrappedProperty(property: Mirror.Child) -> Mirror.Child {
        let mirrored = Mirror(reflecting: property.value)
        let propertyWrapped = mirrored.children.first { (child) -> Bool in
            child.label == "wrappedValue"
        }
        
        if let propertyUnwrapped = propertyWrapped {
            let propertyLabel = property.label?.trimmingCharacters(in: CharacterSet.init(charactersIn: "_"))
            return (label: propertyLabel, value: propertyUnwrapped.value)
        }
        
        return property
    }
    
    private func match(pattern: String, in text: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        if let match = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf8.count)) {
            guard match.numberOfRanges == 2 else {
                return nil
            }
            
            if let typeRange = Range(match.range(at: 1), in: text) {
                return String(text[typeRange])
            }
        }

        return nil
    }
}
