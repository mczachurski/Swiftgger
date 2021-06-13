//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

class OpenAPISchemaUnkeyedEncodingContainer : UnkeyedEncodingContainer {
    let encoder: OpenAPISchemaEncoder
    let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    var codingPath: [CodingKey]
    var count: Int = 0
    
    init(referencing encoder: OpenAPISchemaEncoder, codingPath: [CodingKey], keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.keyEncodingStrategy = keyEncodingStrategy
    }
    
    func encode(_ value: Bool) throws { }
    func encode(_ value: String) throws { }
    func encode(_ value: Double) throws { }
    func encode(_ value: Float) throws { }
    func encode(_ value: Int) throws { }
    func encode(_ value: Int8) throws { }
    func encode(_ value: Int16) throws { }
    func encode(_ value: Int32) throws { }
    func encode(_ value: Int64) throws { }
    func encode(_ value: UInt) throws { }
    func encode(_ value: UInt8) throws { }
    func encode(_ value: UInt16) throws { }
    func encode(_ value: UInt32) throws { }
    func encode(_ value: UInt64) throws { }
    func encode<T>(_ value: T) throws where T : Encodable { }
    func encodeNil() throws { }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let storage = OpenAPISchemaStorage()
        let container = OpenAPISchemaKeyedEncodingContainer<NestedKey>(referencing: self.encoder,
                                                                       codingPath: self.codingPath,
                                                                       wrapping: storage,
                                                                       keyEncodingStrategy: self.keyEncodingStrategy)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return OpenAPISchemaUnkeyedEncodingContainer(referencing: self.encoder,
                                                     codingPath: self.codingPath,
                                                     keyEncodingStrategy: self.keyEncodingStrategy)
    }
    
    func superEncoder() -> Encoder {
        return self.encoder
    }
}
