//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
    func {{name}}Sync({{parametersSync}}{{requestBodySync}}) throws -> HttpResult<{{result}}> {
        let url = baseUrl.appendingPathComponent("{{pathWithParameters}}")
        var request = URLRequest(url: url)
        request.httpMethod = "{{httpMethod}}"{{encodeSync}}
        
        return try URLSession.shared.callSync({{result}}.Self, request: request)
    }

    /**
        {{summary}}

        {{description}}
        Operation path: {{path}}
     */
    func {{name}}Async({{parametersAsync}}{{requestBodyAsync}}completitionHandler: @escaping HttpResultCallback<{{result}}>) -> URLSessionDataTask {
        let url = baseUrl.appendingPathComponent("{{pathWithParameters}}")
        var request = URLRequest(url: url)
        request.httpMethod = "{{httpMethod}}"{{encodeAsync}}

        return URLSession.shared.callAsync({{result}}.Self, request: request, completitionHandler: completitionHandler)
    }

"""
    
    private let encodeSyncTemplate =
"""
        request.httpBody = try JSONEncoder().encode(object)
"""

    private let encodeAsyncTemplate =
"""
        do {
            request.httpBody = try JSONEncoder().encode(object)
        }
        catch {
            completitionHandler(Result.failure(error))
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
                    let method = self.generateMethod(path: path, httpMethod: "GET", operation: operation)
                    methodsString = methodsString + method
                }
            }
            
            if let operation = value.post, let tags = operation.tags {
                if tags.contains(tag.name) {
                    let method = self.generateMethod(path: path, httpMethod: "POST", operation: operation)
                    methodsString = methodsString + method
                }
            }
            
            if let operation = value.put, let tags = operation.tags {
                if tags.contains(tag.name) {
                    let method = self.generateMethod(path: path, httpMethod: "PUT", operation: operation)
                    methodsString = methodsString + method
                }
            }
            
            if let operation = value.delete, let tags = operation.tags {
                if tags.contains(tag.name) {
                    let method = self.generateMethod(path: path, httpMethod: "DELETE", operation: operation)
                    methodsString = methodsString + method
                }
            }
            
            if let operation = value.patch, let tags = operation.tags {
                if tags.contains(tag.name) {
                    let method = self.generateMethod(path: path, httpMethod: "PATCH", operation: operation)
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
    
    private func generateMethod(path: String, httpMethod: String, operation: OpenAPIOperation) -> String {
        let methodName = getMethodName(operation: operation)
        let methodResultType = getMethodResultType(operation: operation)
        let parameters = getParametersList(operation: operation)
        let requestBody = getRequestBody(operation: operation)
        let pathWithParameters = path.replacingOccurrences(of: "{", with: "\\(").replacingOccurrences(of: "}", with: ")")

        var methodString = self.methodTemplate
        methodString = methodString.replacingOccurrences(of: "{{summary}}", with: operation.summary ?? String.empty)
        methodString = methodString.replacingOccurrences(of: "{{description}}", with: operation.description ?? String.empty)
        methodString = methodString.replacingOccurrences(of: "{{path}}", with: path)
        methodString = methodString.replacingOccurrences(of: "{{pathWithParameters}}", with: pathWithParameters)
        methodString = methodString.replacingOccurrences(of: "{{name}}", with: methodName)
        methodString = methodString.replacingOccurrences(of: "{{result}}", with: methodResultType ?? "Void")
        methodString = methodString.replacingOccurrences(of: "{{parametersSync}}",
                                                         with: (requestBody == nil) ? parameters.trimmingCharacters(in: CharacterSet.init(charactersIn: ", ")) : parameters)
        methodString = methodString.replacingOccurrences(of: "{{parametersAsync}}", with: parameters)
        methodString = methodString.replacingOccurrences(of: "{{requestBodyAsync}}", with: requestBody != nil ? "\(requestBody!), " : "")
        methodString = methodString.replacingOccurrences(of: "{{requestBodySync}}", with: requestBody ?? "")
        methodString = methodString.replacingOccurrences(of: "{{encodeSync}}", with: requestBody != nil ? "\n\(encodeSyncTemplate)" : "")
        methodString = methodString.replacingOccurrences(of: "{{encodeAsync}}", with: requestBody != nil ? "\n\n\(encodeAsyncTemplate)" : "")
        methodString = methodString.replacingOccurrences(of: "{{httpMethod}}", with: httpMethod)
        
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
    
    private func getParametersList(operation: OpenAPIOperation) -> String {
        guard let parameters = operation.parameters else {
            return String.empty
        }
        
        var parametersList = String.empty
        parameters.forEach { (parameter) in
            guard let parameterName = parameter.name else {
                return
            }
            
            parametersList = parametersList + "\(parameterName): String, "
        }
        
        return parametersList
    }
    
    private func getRequestBody(operation: OpenAPIOperation) -> String? {
        if let mediaType = operation.requestBody?.content?["application/json"], let schema = mediaType.schema {
            return "object: \(schema.getType())"
        }
        
        return nil
    }
}
