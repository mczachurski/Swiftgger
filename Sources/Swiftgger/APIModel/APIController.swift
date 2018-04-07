//
//  APIController.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Basic information about controller with list of actions.
public class APIController {

    var name: String
    var description: String
    var link: APILink?
    var actions: [APIAction]

    public init(name: String, description: String, externalDocs: APILink? = nil, actions: [APIAction] = []) {
        self.name = name
        self.description = description
        self.link = externalDocs
        self.actions = actions
    }
}
