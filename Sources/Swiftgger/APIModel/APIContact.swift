//
//  APIContact.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 27.03.2018.
//

import Foundation

public class APIContact {

    var name: String?
    var email: String?
    var url: URL?

    public init(name: String? = nil, email: String? = nil, url: URL? = nil) {
        self.name = name
        self.email = email
        self.url = url
    }
}
