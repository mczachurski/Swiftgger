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
    var type: APIResponseType?
    var contentType: String?

    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }

    public init(code: String, description: String, type: APIResponseType?, contentType: String? = nil) {
        self.code = code
        self.description = description
        self.type = type
        self.contentType = contentType
    }
}
