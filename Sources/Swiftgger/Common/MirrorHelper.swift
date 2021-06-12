//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

class MirrorHelper {
    static func getRequiredProperties(properties: Mirror.Children) -> [String] {
        var array: [String] = []

        for property in properties {
            
            // Eventually extract property from property wrapper.
            let unwrappedProperty = self.getWrappedProperty(property: property)
            
            // Append to list of required non optional properties.
            if !isOptional(unwrappedProperty.value) {
                array.append(unwrappedProperty.label!)
            }
        }

        return array
    }

    static func unwrap<T>(_ any: T) -> Any {

        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }

        return first.value
    }
    
    static func convert(valueType any: Any) -> Any {
        if let uuid = any as? UUID {
            return uuid.uuidString
        }
        
        return any
    }
    
    static func convert(arrayType any: Any) -> Any {
        if let uuidArray = any as? [UUID] {
            return uuidArray.map { uuid in uuid.uuidString }
        }
        
        return any
    }

    static func isOptional<T>(_ any: T) -> Bool {
        let mirror = Mirror(reflecting: any)
        return mirror.displayStyle == .optional
    }
    
    static func isInitialized<T>(object any: T) -> Bool {
        let mirror = Mirror(reflecting: any)

        return mirror.displayStyle == .struct
            || mirror.displayStyle == .class
            || mirror.displayStyle == .enum
    }
    
    static func getTypeName(from any: Any) -> String? {
        let typeName = String(describing: type(of: any))
        
        let pattern = "^Optional<(?<type>\\w+)>$"
        return self.match(pattern: pattern, in: typeName)
    }

    static func getArrayTypeName(from any: Any) -> String? {
        let typeName = String(describing: type(of: any))
        
        let pattern = "^Optional<Array<(?<type>\\w+)>>$"
        return self.match(pattern: pattern, in: typeName)
    }
    
    static func getWrappedProperty(property: Mirror.Child) -> Mirror.Child {
        let mirrored = Mirror(reflecting: property.value)
        let propertyWrapped = mirrored.children.first { (child) -> Bool in
            child.label == "wrappedValue"
        }
        
        if let propertyUnwrapped = propertyWrapped {
            let propertyLabel = property.label?.trimmingCharacters(in: CharacterSet.init(charactersIn: "_"))
            return (label: propertyLabel, value: propertyUnwrapped.value)
        }
        
        return property
    }
    
    static func match(pattern: String, in text: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        if let match = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf8.count)) {
            guard match.numberOfRanges == 2 else {
                return nil
            }
            
            if let typeRange = Range(match.range(at: 1), in: text) {
                return String(text[typeRange])
            }
        }

        return nil
    }
}
