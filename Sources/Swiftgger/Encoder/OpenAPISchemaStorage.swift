//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

class OpenAPISchemaStorage {
    var container: [String: OpenAPISchema] = [:]
    var collection: [OpenAPISchema] = []
    
    func push(property: String, withParameters schema: OpenAPISchema) {
        self.container[property] = schema
    }
    
    func push(parameter: OpenAPISchema) {
        self.collection.append(parameter)
    }
}
