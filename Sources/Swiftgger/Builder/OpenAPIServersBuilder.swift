//
//  OpenAPIServerBuilder.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class OpenAPIServersBuilder {

    let servers: [APIServer]

    init(servers: [APIServer]) {
        self.servers = servers
    }

    func build() -> [OpenAPIServer] {
        var openAPIServers: [OpenAPIServer] = []

        for server in self.servers {

            let openAPIServerVariables = self.getServerVariables(variables: server.variables)

            let server = OpenAPIServer(
                url: server.url,
                description: server.description,
                variables: openAPIServerVariables
            )

            openAPIServers.append(server)
        }

        return openAPIServers
    }

    private func getServerVariables(variables: [APIVariable]?) -> [String: OpenAPIServerVariable]? {

        guard let apiVariables = variables else {
            return nil
        }

        var openAPIServerVariables: [String: OpenAPIServerVariable] = [:]
        for variable in apiVariables {
            let openAPIServerVariable = OpenAPIServerVariable(
                defaultValue: variable.defaultValue,
                enumValues: variable.enumValues,
                description: variable.description
            )

            openAPIServerVariables[variable.name] = openAPIServerVariable
        }

        return openAPIServerVariables
    }
}
