//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
            let required = MirrorHelper.getRequiredProperties(properties: requestMirror.children)
            let properties = self.getAllProperties(properties: requestMirror.children)
            let requestSchema = OpenAPISchema(type: "object", required: required, properties: properties)
            schemas[mirrorObjectType] = requestSchema
        }
    }

    private func getAllProperties(properties: Mirror.Children) -> [(name: String, type: OpenAPISchema)] {
        var array:  [(name: String, type: OpenAPISchema)] = []
        for property in properties {
            
            // Eventually extract property from property wrapper.
            let unwrappedProperty = MirrorHelper.getWrappedProperty(property: property)
            
            // Append property with correct type to array.
            self.appendProperty(property: unwrappedProperty, array: &array)
        }

        return array
    }
    
    private func appendProperty(property: Mirror.Child, array: inout [(name: String, type: OpenAPISchema)]) {

        // Simple value type (also unwrapped optionals).
        let unwrapped = MirrorHelper.unwrap(property.value)
        if let dataType = APIDataType(fromSwiftValue: unwrapped) {
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
        if MirrorHelper.isInitialized(object: unwrapped) {
            self.append(reference: property, array: &array)
            return
        }
        
        // Optional and not initialized object.
        if let typeName = MirrorHelper.getTypeName(from: unwrapped) {
            self.append(typeName: typeName, property: property, array: &array)
            return
        }
        
        // Optional and not initialized arrays.
        if let typeName = MirrorHelper.getArrayTypeName(from: unwrapped) {
            self.append(arrayName: typeName, property: property, array: &array)
            return
        }
    }

    private func append(dataType: APIDataType,
                        property: Mirror.Child,
                        unwrapped: Any,
                        array: inout [(name: String, type: OpenAPISchema)]
    ) {
        let exampleValue = MirrorHelper.convert(valueType: unwrapped)
        let example = AnyCodable(exampleValue)
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

        let unwrapped = MirrorHelper.unwrap(item)
        if let dataType = APIDataType(fromSwiftValue: unwrapped) {
            let exampleValue = MirrorHelper.convert(arrayType: items)
            let example = AnyCodable(exampleValue)
            let openApiSchema = OpenAPISchema(type: dataType.type, format: dataType.format)
            let objectProperty = OpenAPISchema(type: APIDataType.array.type, items: openApiSchema, example: example)

            array.append((name: property.label ?? "", type: objectProperty))
        } else {
            let typeName = String(describing: type(of: item))
            let openApiSchema = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
            let objectProperty = OpenAPISchema(type: APIDataType.array.type, items: openApiSchema)

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
        
        let unwrapped = MirrorHelper.unwrap(item.value)
        if let dataType = APIDataType(fromSwiftValue: unwrapped) {
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
        let unwrapped = MirrorHelper.unwrap(reference.value)
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
        let objectProperty = OpenAPISchema(type: APIDataType.array.type, items: openApiSchema)
        array.append((name: property.label ?? "", type: objectProperty))
    }
}
