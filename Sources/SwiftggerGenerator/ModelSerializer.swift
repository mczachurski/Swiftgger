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
    
    private let classTemplate =
"""
import Foundation

class {{name}} {
    {{properties}}
}
"""
    
    private let propertyTemplate = "    public {{name}}: {{type}}{{isRequired}}\n"
    
    func generate(openApiDocument: OpenAPIDocument, outputPath: String) throws {
        
        guard let schemas = openApiDocument.components?.schemas else {
            return
        }
        
        for (key, value) in schemas {
            let definition = self.generateClass(name: key, schema: value)
            try definition.saveTo(fileName: key, andPath: outputPath)
        }
    }
    
    private func generateClass(name: String, schema: OpenAPISchema) -> String {
        var propertiesString = String.empty
        
        if let properties = schema.properties {
            for (propertyName, property) in properties {
                let isRequired = self.isRequired(required: schema.required, property: propertyName)
                let property = self.generateProperty(name: propertyName, property: property, isRequired: isRequired)

                propertiesString = propertiesString + property
            }
        }

        propertiesString = propertiesString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var classString = self.classTemplate
        classString = classString.replacingOccurrences(of: "{{name}}", with: name)
        classString = classString.replacingOccurrences(of: "{{properties}}", with: propertiesString)
        
        return classString
    }
    
    private func isRequired(required: [String]?, property: String) -> Bool {
        return required?.contains(property) ?? false
    }
    
    private func generateProperty(name: String, property: OpenAPISchema, isRequired: Bool) -> String {
        let type = property.getType()
        
        var propertyString = self.propertyTemplate
        propertyString = propertyString.replacingOccurrences(of: "{{name}}", with: name)
        propertyString = propertyString.replacingOccurrences(of: "{{type}}", with: type)
        propertyString = propertyString.replacingOccurrences(of: "{{isRequired}}", with: isRequired ? "" : "?")
        
        return propertyString
    }
}
