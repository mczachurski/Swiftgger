//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

class OpenAPISchemaConverter {
    let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    
    init(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) {
        self.keyEncodingStrategy = keyEncodingStrategy
    }
    
    func convert<T : Encodable>(_ value: T, referencedObjects: [String]) -> [String: OpenAPISchema] {
        let encoder = OpenAPISchemaEncoder(referencedObjects: referencedObjects,
                                           keyEncodingStrategy: self.keyEncodingStrategy)

        guard let schema = try? encoder.process(value) else {
            return [:]
        }

        return schema
    }
}
