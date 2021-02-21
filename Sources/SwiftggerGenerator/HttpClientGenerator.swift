//
//  HttpClientGenerator.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 20/02/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import Swiftgger

public class HttpClientGenerator {
    
    private let classTemplate =
"""
import Foundation

/**
    {{comment}}
 */
class {{name}} {
    private baseUrl: URL

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    {{methods}}
}
"""
    
    private let methodTemplate =
"""
    /**
        {{summary}}

        {{description}}
        Operation path: {{path}}
     */
    func {{name}}(){{result}} {
    }


"""
    
    func generate(openApiDocument: OpenAPIDocument, outputPath: String) throws {
        guard let tags = openApiDocument.tags else {
            return
        }

        for tag in tags {
            let definition = self.generateClass(tag: tag, openApiDocument: openApiDocument)
            try definition.saveTo(fileName: "\(tag.name)Client", andPath: outputPath)
        }
    }
    
    private func generateClass(tag: OpenAPITag, openApiDocument: OpenAPIDocument) -> String {
        var methodsString = String.empty
        
        for (path, value) in openApiDocument.paths {
            if let operation = value.get, let tags = operation.tags {
                if tags.contains(tag.name) {
                    let method = self.generateMethod(path: path, operation: operation)
                    methodsString = methodsString + method
                }
            }
        }
        
        methodsString = methodsString.trimmingCharacters(in: .whitespacesAndNewlines)

        var classString = self.classTemplate
        classString = classString.replacingOccurrences(of: "{{comment}}", with: tag.description ?? tag.name)
        classString = classString.replacingOccurrences(of: "{{name}}", with: tag.name)
        classString = classString.replacingOccurrences(of: "{{methods}}", with: methodsString)
        
        return classString
    }
    
    private func generateMethod(path: String, operation: OpenAPIOperation) -> String {
        let methodName = getMethodName(operation: operation)
        let methodResult = getMethodResult(operation: operation)

        var methodString = self.methodTemplate
        methodString = methodString.replacingOccurrences(of: "{{summary}}", with: operation.summary ?? String.empty)
        methodString = methodString.replacingOccurrences(of: "{{description}}", with: operation.description ?? String.empty)
        methodString = methodString.replacingOccurrences(of: "{{path}}", with: path)
        methodString = methodString.replacingOccurrences(of: "{{name}}", with: methodName)
        methodString = methodString.replacingOccurrences(of: "{{result}}", with: methodResult)

        return methodString
    }
    
    private func getMethodName(operation: OpenAPIOperation) -> String {
        guard let summary = operation.summary else {
            return "missingPathSummary"
        }
        
        var methodName = ""
        let words = summary.components(separatedBy: " ")
        for (index, word) in words.enumerated() {
            if index == 0 {
                methodName.append(word.lowercasingFirstLetter())
            } else {
                methodName.append(word.capitalizingFirstLetter())
            }
        }
        
        return methodName
    }
    
    private func getMethodResult(operation: OpenAPIOperation) -> String {
        let methodResultType = getMethodResultType(operation: operation)
        guard let methodResult = methodResultType else {
            return String.empty
        }
        
        return " -> Result<\(methodResult), Error>"
    }
    
    private func getMethodResultType(operation: OpenAPIOperation) -> String? {
        guard let responses = operation.responses else {
            return nil
        }
        
        if let successResponse = responses["200"] {
            if let mediaType = successResponse.content?["application/json"], let schema = mediaType.schema {
                return schema.getType()
            }
        }

        if let successResponse = responses["201"] {
            if let mediaType = successResponse.content?["application/json"], let schema = mediaType.schema {
                return schema.getType()
            }
        }
        
        return nil
    }
}
