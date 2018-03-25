//
//  APIResponse.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class APIResponse {
    var object: Any?
    var description: String
    var code: String
    var contentType: String?

    init(code: String, description: String, object: Any? = nil, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.object = object
        self.contentType = contentType
    }
}
