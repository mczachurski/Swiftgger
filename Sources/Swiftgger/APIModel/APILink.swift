//
//  APILink.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

class APILink {

    var url: String
    var description: String?

    init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
