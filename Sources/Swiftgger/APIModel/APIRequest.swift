//
//  APIRequest.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

public class APIRequest {
    var object: Any?
    var description: String?
    var contentType: String?

    public init(object: Any? = nil, description: String? = nil, contentType: String? = nil) {
        self.object = object
        self.description = description
        self.contentType = contentType
    }
}
