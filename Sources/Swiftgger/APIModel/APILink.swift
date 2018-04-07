//
//  APILink.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 25.03.2018.
//

import Foundation

/// Link to external documentation.
public class APILink {

    var url: String
    var description: String?

    public init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
