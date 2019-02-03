//
//  APIDataType.swift
//  Swiftgger
//
//  Created by Eneko Alonso on 2/2/19.
//

import Foundation

/// OpenAPI Data Types as specified in https://swagger.io/specification/#dataTypes
public struct APIDataType {
    let type: String
    let format: String?

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
}
