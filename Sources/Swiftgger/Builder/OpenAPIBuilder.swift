//
//  OpenAPIBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class OpenAPIBuilder {

    var title: String
    var version: String
    var description: String
    var termsOfService: String?
    var name: String?
    var email: String?
    var url: URL?
    var authorizations: [APIAuthorizationType]?

    var controllers: [APIController] = []
    var servers: [APIServer] = []

    public init(
        title: String,
        version: String,
        description: String,
        termsOfService: String? = nil,
        name: String? = nil,
        email: String? = nil,
        url: URL? = nil,
        authorizations: [APIAuthorizationType]? = nil
    ) {
        self.title = title
        self.version = version
        self.description = description
        self.termsOfService = termsOfService
        self.name = name
        self.email = email
        self.url = url
        self.authorizations = authorizations
    }

    public func addController(_ controller: APIController) -> OpenAPIBuilder {
        self.controllers.append(controller)
        return self
    }

    public func addServer(_ server: APIServer) -> OpenAPIBuilder {
        self.servers.append(server)
        return self
    }

    public func build() throws -> OpenAPIDocument {

        // Basic controller information.
        let contact = OpenAPIContact(name: self.name, email: self.email, url: self.url)
        let info = OpenAPIInfo(
            title: self.title,
            version: self.version,
            description: self.description,
            termsOfService: self.termsOfService,
            contact: contact
        )

        // Create information about tags (controllers).
        let openAPITagsBuilder = OpenAPITagsBuilder(controllers: self.controllers)
        let tags = openAPITagsBuilder.build()

        // Create information about security schemas (authorizations).
        let openAPISecurityBuilder = OpenAPISecurityBuilder(authorizations: self.authorizations)
        let openAPISecuritySchemas = openAPISecurityBuilder.build()

        // Create information about servers (requessts will be send to them).
        let openAPIServersBuilder = OpenAPIServersBuilder(servers: servers)
        let openAPIServers = openAPIServersBuilder.build()

        // Create information about schemas (objects).
        let openAPISchemasBuilder = OpenAPISchemasBuilder(controllers: self.controllers)
        let schemas = openAPISchemasBuilder.build()

        // Create information about paths (actions).
        let openAPIPathsBuilder = OpenAPIPathsBuilder(controllers: self.controllers, authorizations: self.authorizations)
        let paths = openAPIPathsBuilder.build()

        let components = OpenAPIComponents(schemas: schemas, securitySchemes: openAPISecuritySchemas)
        return OpenAPIDocument(info: info, paths: paths, servers: openAPIServers, tags: tags, components: components)
    }
}
