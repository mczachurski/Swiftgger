//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

class OpenAPISchemaConverter {
    open func convert<T : Encodable>(_ value: T, referencedObjects: [String]) -> [String: OpenAPISchema] {
        let encoder = OpenAPISchemaEncoder(referencedObjects: referencedObjects)

        guard let schema = try? encoder.process(value) else {
            return [:]
        }

        return schema
    }
}
