//
//  OpenAPIServer.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/// An object representing a Server (address).
public class OpenAPIServer: Encodable {

    public private(set) var url: String
    public private(set) var description: String?
    public private(set) var variables: [String: OpenAPIServerVariable]?

    init(url: String, description: String? = nil, variables: [String: OpenAPIServerVariable]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}
