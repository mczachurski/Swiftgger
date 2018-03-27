//
//  APIResponse.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class APIResponse {
    var code: String
    var description: String
    var object: Any?
    var contentType: String?

    public init(code: String, description: String, object: Any? = nil, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.object = object
        self.contentType = contentType
    }
}
