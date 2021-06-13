//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import AnyCodable

class OpenAPISchemaKeyedEncodingContainer<Key : CodingKey> : KeyedEncodingContainerProtocol {
    let encoder: OpenAPISchemaEncoder
    var codingPath: [CodingKey]
    var storage: OpenAPISchemaStorage
    
    init(referencing encoder: OpenAPISchemaEncoder, codingPath: [CodingKey], wrapping storage: OpenAPISchemaStorage) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.storage = storage
    }
    
    func encodeNil(forKey key: Key) throws {
        print("(OpenAPISchemaKeyedEncodingContainer) Not supported encodeNil()")
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.boolean.type, format: APIDataType.boolean.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.string.type, format: APIDataType.string.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.double.type, format: APIDataType.double.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Float, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.float.type, format: APIDataType.float.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int64.type, format: APIDataType.int64.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.int64.type, format: APIDataType.int64.format, example: AnyCodable(value)))
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        // Collections.
        if let items = value as? Array<Any> {
            self.append(items: items, forKey: key)
            return
        }
        
        // Dictionaries.
        if let items = value as? Dictionary<String, Any> {
            self.append(dictionary: items, forKey: key)
            return
        }
        
        // Date.
        if let date = value as? Date {
            self.append(date: date, forKey: key)
            return
        }
        
        // UUID.
        if let uuid = value as? UUID {
            self.append(uuid: uuid, forKey: key)
            return
        }
        
        // Referenced object.
        if self.isTypeReferenced(value) {
            self.append(reference: value, forKey: key)
            return
        }
        
        // Unknown objects (also property wrappers).
        self.append(complex: value, forKey: key)
    }
    
    private func append(items: Array<Any>, forKey key: Key) {
        guard let item = items.first else {
            return
        }

        let unwrapped = MirrorHelper.unwrap(item)
        if let dataType = APIDataType(fromSwiftValue: unwrapped) {
            let exampleValue = MirrorHelper.convert(arrayType: items)
            let example = AnyCodable(exampleValue)
            let openApiSchema = OpenAPISchema(type: dataType.type, format: dataType.format)
            let objectProperty = OpenAPISchema(type: APIDataType.array.type, items: openApiSchema, example: example)

            storage.push(property: key.stringValue, withParameters: objectProperty)
            
        } else {
            guard self.isTypeReferenced(item) else {
                return
            }
            
            let typeName = String(describing: type(of: item))
            let openApiSchema = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
            let objectProperty = OpenAPISchema(type: APIDataType.array.type, items: openApiSchema)
            storage.push(property: key.stringValue, withParameters: objectProperty)
        }
    }
    
    private func append(dictionary: Dictionary<String, Any>, forKey key: Key) {
        guard let item = dictionary.first else {
            return
        }
        
        let unwrapped = MirrorHelper.unwrap(item.value)
        if let dataType = APIDataType(fromSwiftValue: unwrapped) {
            let additionalProperties = OpenAPISchema(type: dataType.type, format: dataType.format)
            let objectProperty = OpenAPISchema(type: "object", additionalProperties: additionalProperties)

            storage.push(property: key.stringValue, withParameters: objectProperty)
        } else {
            guard self.isTypeReferenced(item.value) else {
                return
            }
            
            let typeName = String(describing: type(of: item.value))
            let additionalProperties = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
            let objectProperty = OpenAPISchema(type: "object", additionalProperties: additionalProperties)
            storage.push(property: key.stringValue, withParameters: objectProperty)
        }
    }
        
    private func append<T>(reference value: T, forKey key: Key) where T : Encodable {
        guard self.isTypeReferenced(value) else {
            return
        }
        
        let typeName = String(describing: type(of: value))
        let objectProperty = OpenAPISchema(ref: "#/components/schemas/\(typeName)")
        storage.push(property: key.stringValue, withParameters: objectProperty)
    }
    
    private func append(uuid: UUID, forKey key: Key) {
        let objectProperty = OpenAPISchema(type: APIDataType.uuid.type, format: APIDataType.uuid.format, example: AnyCodable(uuid.uuidString))
        storage.push(property: key.stringValue, withParameters: objectProperty)
    }
    
    private func append(date: Date, forKey key: Key) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: date)
        
        storage.push(property: key.stringValue,
                     withParameters: OpenAPISchema(type: APIDataType.dateTime.type, format: APIDataType.dateTime.format, example: AnyCodable(dateString)))
    }
    
    private func append<T>(complex value: T, forKey key: Key) where T : Encodable {
        
        let internalEncoder = OpenAPISchemaEncoder(codingPath: [], referencedObjects: self.encoder.referencedObjects)
        try? value.encode(to: internalEncoder)
        
        // Encode simple values (e.g. property wrappers simple values).
        if let schemaItem = internalEncoder.storage.collection.first {
            storage.push(property: key.stringValue, withParameters: schemaItem)
            return
        }
        
        // Encode complex objects.
        if internalEncoder.storage.container.isEmpty == false {
            let objectProperty = OpenAPISchema(type: "object", properties: internalEncoder.storage.container)
            storage.push(property: key.stringValue, withParameters: objectProperty)
        }
    }
    
    private func isTypeReferenced(_ value: Any) -> Bool {
        let typeName = String(describing: type(of: value))
        return self.encoder.referencedObjects.contains(where: { referencedObject in referencedObject == typeName })
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = OpenAPISchemaKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: codingPath, wrapping: storage)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return OpenAPISchemaUnkeyedEncodingContainer(referencing: encoder, codingPath: codingPath)
    }
    
    func superEncoder() -> Encoder {
        return self.encoder
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return self.encoder
    }
}
