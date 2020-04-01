//
//  APIDataType.swift
//  Swiftgger
//
//  Created by Eneko Alonso on 2/2/19.
//

import Foundation

/// OpenAPI Data Types as specified in https://swagger.io/specification/#dataTypes
public struct APIDataType {
    let type: String?
    let format: String?
    let ref: String?

    public static let int32 = APIDataType(type: "integer", format: "int32", ref: nil)
    public static let int64 = APIDataType(type: "integer", format: "int64", ref: nil)
    public static let float = APIDataType(type: "number", format: "float", ref: nil)
    public static let double = APIDataType(type: "number", format: "double", ref: nil)
    public static let string = APIDataType(type: "string", format: nil, ref: nil)
    public static let byte = APIDataType(type: "string", format: "byte", ref: nil)
    public static let binary = APIDataType(type: "string", format: "binary", ref: nil)
    public static let boolean = APIDataType(type: "boolean", format: nil, ref: nil)
    public static let date = APIDataType(type: "string", format: "date", ref: nil)
    public static let dateTime = APIDataType(type: "string", format: "date-time", ref: nil)
    public static let password = APIDataType(type: "string", format: "password", ref: nil)
}
