//
//  ModelSerializer.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 20/02/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import Swiftgger

class ModelSerializer {
    func generate(openApiDocument: OpenAPIDocument, outputPath: String) throws {
        
        guard let schemas = openApiDocument.components?.schemas else {
            return
        }
        
        for (key, value) in schemas {
            let definition = self.generateClass(name: key, schema: value)
            try self.createFile(name: key, content: definition, outputPath: outputPath)
        }
    }
    
    private func createFile(name: String, content: String, outputPath: String) throws {
        guard let data = content.data(using: .utf8) else {
            throw SwiftggerError.dataNotDownloaded
        }
        
        let location = URL(fileURLWithPath: "\(outputPath)/\(name).swift")
        try data.write(to: location)
    }
    
    private func generateClass(name: String, schema: OpenAPISchema) -> String {
        var definition =
"""
import Foundation

class \(name) {

"""

        if let properties = schema.properties {
            for (key, value) in properties {
                let isRequired = self.isRequired(required: schema.required, property: key)
                let property = self.generateProperty(name: key, property: value, isRequired: isRequired)
                definition = definition + property
            }
        }

        definition = definition +
"""
}
"""

        return definition
    }
    
    private func isRequired(required: [String]?, property: String) -> Bool {
        return required?.contains(property) ?? false
    }
    
    private func generateProperty(name: String, property: OpenAPISchema, isRequired: Bool) -> String {
        let type = self.getType(property: property)
        return "    public \(name): \(type)\(isRequired ? "" : "?")\n"
    }
    
    private func getType(property: OpenAPISchema) -> String {
        if let additionalProperties = property.additionalProperties {
            if let ref = additionalProperties.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return "[String: \(type)]"
            } else {
                let type = self.getType(type: additionalProperties.type, format: additionalProperties.format)
                return "[String: \(type)]"
            }
        }
        else if let items = property.items {
            if let ref = items.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return "[\(type)]"
            } else {
                let type = self.getType(type: items.type, format: items.format)
                return "[\(type)]"
            }
        } else {
            if let ref = property.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return type
            } else {
                return self.getType(type: property.type, format: property.format)
            }
        }
    }
    
    private func getType(type: String?, format: String?) -> String {
                
        switch type {
        case "boolean":
            return "Bool"
        case "integer":
            return "Int"
        case "number":
            if format == "float" {
                return "Float"
            }
            
            return "Double"
        default:
            if format == "date" {
                return "Date"
            }

            return "String"
        }
    }
}
