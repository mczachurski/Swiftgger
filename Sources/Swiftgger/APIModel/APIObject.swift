//
//  APIObject.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 02.04.2018.
//

import Foundation

/// Information about (request/response) Swift object.
public class APIObject {
    let object: Any
    let defaultName: String
    let customName: String?

    public init(object: Any, customName: String? = nil) {
        self.object = object
        self.customName = customName
        self.defaultName = String(describing: type(of: object))
    }
}
