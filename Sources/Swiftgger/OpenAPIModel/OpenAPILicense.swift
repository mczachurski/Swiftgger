//
//  OpenAPILicense.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/// Information about license for the exposed API.
public class OpenAPILicense: Encodable {

    public private(set) var name: String
    public private(set) var url: URL?

    init(name: String, url: URL? = nil) {
        self.name = name
        self.url = url
    }
}
