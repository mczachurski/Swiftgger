//
//  APILicense.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 27.03.2018.
//

import Foundation

public class APILicense {

    var name: String
    var url: URL?

    public init(name: String, url: URL? = nil) {
        self.name = name
        self.url = url
    }
}
