//
//  APIServer.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class APIServer {

    var url: String
    var description: String?
    var variables: [APIVariable]?

    init(url: String, description: String? = nil, variables: [APIVariable]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}
