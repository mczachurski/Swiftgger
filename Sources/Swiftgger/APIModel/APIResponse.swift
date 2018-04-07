//
//  APIResponse.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Information about HTTP response.
public class APIResponse {
    var code: String
    var description: String
    var object: Any.Type?
    var array: Any.Type?
    var contentType: String?

    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }

    public init(code: String, description: String, object: Any.Type?, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.object = object
        self.contentType = contentType
    }

    public init(code: String, description: String, array: Any.Type?, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.array = array
        self.contentType = contentType
    }
}
