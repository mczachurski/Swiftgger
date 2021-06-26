//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// OpenAPI Data Types as specified in https://swagger.io/specification/#dataTypes
public struct APIDataType {
    let type: String
    let format: String?
}

extension APIDataType {
    /// Infer OpenAPI Data Type from Swift value type
    ///
    /// - Parameter value: Swift property value to analyze
    /// - Returns: Most appropriate OpenAPI Data Type
    init?(fromSwiftValue value: Any) {
        switch value {
        case is Int32:
            self.type = "integer"
            self.format = "int32"
        case is Int:
            self.type = "integer"
            self.format = "int64"
        case is Float:
            self.type = "number"
            self.format = "float"
        case is Double:
            self.type = "number"
            self.format = "double"
        case is Bool:
            self.type = "boolean"
            self.format = nil
        case is Date:
            self.type = "string"
            self.format = "date"
        case is String:
            self.type = "string"
            self.format = nil
        case is UUID:
            self.type = "string"
            self.format = "uuid"
        default:
            return nil
        }
    }
    
    init?(fromSwiftType type: Any.Type) {
        switch type {
        case is Int32.Type:
            self.type = "integer"
            self.format = "int32"
        case is Int.Type:
            self.type = "integer"
            self.format = "int64"
        case is Float.Type:
            self.type = "number"
            self.format = "float"
        case is Double.Type:
            self.type = "number"
            self.format = "double"
        case is Bool.Type:
            self.type = "boolean"
            self.format = nil
        case is Date.Type:
            self.type = "string"
            self.format = "date"
        case is String.Type:
            self.type = "string"
            self.format = nil
        case is UUID.Type:
            self.type = "string"
            self.format = "uuid"
        default:
            return nil
        }
    }
}

extension APIDataType {
    public static let array = APIDataType(type: "array", format: nil)
    public static let int32 = APIDataType(type: "integer", format: "int32")
    public static let int64 = APIDataType(type: "integer", format: "int64")
    public static let float = APIDataType(type: "number", format: "float")
    public static let double = APIDataType(type: "number", format: "double")
    public static let string = APIDataType(type: "string", format: nil)
    public static let byte = APIDataType(type: "string", format: "byte")
    public static let binary = APIDataType(type: "string", format: "binary")
    public static let boolean = APIDataType(type: "boolean", format: nil)
    public static let date = APIDataType(type: "string", format: "date")
    public static let dateTime = APIDataType(type: "string", format: "date-time")
    public static let password = APIDataType(type: "string", format: "password")
    public static let uuid = APIDataType(type: "string", format: "uuid")
}
