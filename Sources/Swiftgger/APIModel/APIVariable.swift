//
//  APIVariable.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

class APIVariable: Encodable {

    var name: String
    var defaultValue: String
    var enumValues: [String]?
    var description: String?

    init(name: String, defaultValue: String, enumValues: [String]? = nil, description: String? = nil) {
        self.name = name
        self.defaultValue = defaultValue
        self.enumValues = enumValues
        self.description = description
    }
}
