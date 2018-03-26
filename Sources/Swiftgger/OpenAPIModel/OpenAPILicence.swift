//
//  OpenAPILicence.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// License information for the exposed API.
public class OpenAPILicence: Encodable {

    public private(set) var name: String
    public private(set) var url: String?

    init(name: String, url: String? = nil) {
        self.name = name
        self.url = url
    }
}
