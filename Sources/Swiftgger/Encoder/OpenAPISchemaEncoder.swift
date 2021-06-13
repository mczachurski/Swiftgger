//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import AnyCodable

class OpenAPISchemaEncoder: Encoder {
    let userInfo: [CodingUserInfoKey : Any]
    let codingPath: [CodingKey]
    let storage: OpenAPISchemaStorage
    let referencedObjects: [String]
    let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    
    init(codingPath: [CodingKey] = [], referencedObjects: [String] = [], keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) {
        self.userInfo = [:]
        self.codingPath = codingPath
        self.referencedObjects = referencedObjects
        self.keyEncodingStrategy = keyEncodingStrategy
        self.storage = OpenAPISchemaStorage()
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = OpenAPISchemaKeyedEncodingContainer<Key>(referencing: self,
                                                                 codingPath: self.codingPath,
                                                                 wrapping: storage,
                                                                 keyEncodingStrategy: self.keyEncodingStrategy)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return OpenAPISchemaUnkeyedEncodingContainer(referencing: self,
                                                     codingPath: self.codingPath,
                                                     keyEncodingStrategy: self.keyEncodingStrategy)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
    
    func process(_ value: Encodable) throws -> [String: OpenAPISchema] {
        try value.encode(to: self)
        return self.storage.container
    }
}

extension OpenAPISchemaEncoder : SingleValueEncodingContainer {
    public func encodeNil() throws {
        print("(OpenAPISchemaEncoder) Not supported encodeNil()")
    }

    public func encode(_ value: Bool) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.boolean.type, format: APIDataType.boolean.format, example: AnyCodable(value)))
    }

    public func encode(_ value: Int) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: Int8) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }

    public func encode(_ value: Int16) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: Int32) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: Int64) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int64.type, format: APIDataType.int64.format, example: AnyCodable(value)))
    }

    public func encode(_ value: UInt) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: UInt8) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: UInt16) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: UInt32) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int32.type, format: APIDataType.int32.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: UInt64) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.int64.type, format: APIDataType.int64.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: String) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.string.type, format: APIDataType.string.format, example: AnyCodable(value)))
    }

    public func encode(_ value: Float) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.float.type, format: APIDataType.float.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: Double) throws {
        self.storage.push(parameter: OpenAPISchema(type: APIDataType.double.type, format: APIDataType.double.format, example: AnyCodable(value)))
    }
    
    public func encode(_ value: IndexSet) throws {
        print("(OpenAPISchemaEncoder) Not supported encode(IndexSet)")
    }

    public func encode<T : Encodable>(_ value: T) throws {
        try value.encode(to: self)
    }
}
