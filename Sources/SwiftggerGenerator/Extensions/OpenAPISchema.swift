//
//  File.swift
//  
//
//  Created by Marcin Czachurski on 21/02/2021.
//

import Foundation
import Swiftgger

extension OpenAPISchema {
    
    func getType() -> String {
        if let additionalProperties = self.additionalProperties {
            if let ref = additionalProperties.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return "[String: \(type)]"
            } else {
                let type = self.getType(type: additionalProperties.type, format: additionalProperties.format)
                return "[String: \(type)]"
            }
        }
        else if let items = self.items {
            if let ref = items.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return "[\(type)]"
            } else {
                let type = self.getType(type: items.type, format: items.format)
                return "[\(type)]"
            }
        } else {
            if let ref = self.ref {
                let type = ref.deletingPrefix("#/components/schemas/")
                return type
            } else {
                return self.getType(type: self.type, format: self.format)
            }
        }
    }
    
    func getType(type: String?, format: String?) -> String {
                
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
