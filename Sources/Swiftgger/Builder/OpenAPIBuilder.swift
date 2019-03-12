//
//  OpenAPIBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

/// Builder for OpenAPI documentation.
public class OpenAPIBuilder {

    var title: String
    var version: String
    var description: String
    var termsOfService: String?
    var contact: APIContact?
    var license: APILicense?
    var authorizations: [APIAuthorizationType]?

    var controllers: [APIController] = []
    var servers: [APIServer] = []
    var objects: [APIObject] = []

    /**
        Initializes a instance of OpenAPI documentation builder.

        - Parameters:
     
            - title: Title of API
            - version: Versio of API
            - description: Description of API
            - termsOfService: Terms of service
            - contact: Terms of service
            - license: Terms of service
            - authorizations: Terms of service
     */
    public init(
        title: String,
        version: String,
        description: String,
        termsOfService: String? = nil,
        contact: APIContact? = nil,
        license: APILicense? = nil,
        authorizations: [APIAuthorizationType]? = nil
    ) {
        self.title = title
        self.version = version
        self.description = description
        self.termsOfService = termsOfService
        self.contact = contact
        self.license = license
        self.authorizations = authorizations
    }

    /**
        Add new controller to the OpenAPI description.

        - Parameter controller: Information about controller.

        - Returns: Same OpenAPI builder.
    */
    public func add(_ controller: APIController) -> OpenAPIBuilder {
        self.controllers.append(controller)
        return self
    }

    /**
        Add new server information to the OpenAPI description.

        - Parameter server: Information about server.

        - Returns: Same OpenAPI builder.
    */
    public func add(_ server: APIServer) -> OpenAPIBuilder {
        self.servers.append(server)
        return self
    }

    /**
        Add new objects to the OpenAPI description.

        - Parameter objects: List of objects which will be added to the OpenAPI description.

        - Returns: Same OpenAPI builder.
    */
    public func add(_ objects: [APIObject]) -> OpenAPIBuilder {
        self.objects.append(contentsOf: objects)
        return self
    }

    /**
        Method which is responsible for build OpenAPI document.

        - Returns: Object with OpenAPI specification.
    */
    public func built() -> OpenAPIDocument {

        // Create basic controller information (info).
        let openAPIInfoBuilder = OpenAPIInfoBuilder(title: self.title,
                                             version: self.version,
                                             description: self.description,
                                             termsOfService: self.termsOfService,
                                             contact: self.contact,
                                             license: self.license)
        let info = openAPIInfoBuilder.built()

        // Create information about tags (controllers).
        let openAPITagsBuilder = OpenAPITagsBuilder(controllers: self.controllers)
        let tags = openAPITagsBuilder.built()

        // Create information about security schemas (authorizations).
        let openAPISecurityBuilder = OpenAPISecurityBuilder(authorizations: self.authorizations)
        let openAPISecuritySchemas = openAPISecurityBuilder.built()

        // Create information about servers (requessts will be send to them).
        let openAPIServersBuilder = OpenAPIServersBuilder(servers: servers)
        let openAPIServers = openAPIServersBuilder.built()

        // Create information about schemas (objects).
        let openAPISchemasBuilder = OpenAPISchemasBuilder(objects: self.objects)
        let schemas = openAPISchemasBuilder.built()
        let customSchemaNames = generateCustomNameMapping(from: self.objects)

        // Create information about paths (actions).
        let openAPIPathsBuilder = OpenAPIPathsBuilder(controllers: self.controllers, authorizations: self.authorizations, customSchemaNames: customSchemaNames)
        let paths = openAPIPathsBuilder.built()

        let components = OpenAPIComponents(schemas: schemas, securitySchemes: openAPISecuritySchemas)
        return OpenAPIDocument(info: info, paths: paths, servers: openAPIServers, tags: tags, components: components)
    }

    private func generateCustomNameMapping(from objects: [APIObject]) -> [String: String] {      
      var result: [String: String] = [:]
      objects.forEach {
        guard let object = $0.object,
              let customName = $0.customName else {
            return
        }
        let defaultName = String(describing: type(of: object))
        result[defaultName] = customName
      }
      return result
    }
}
