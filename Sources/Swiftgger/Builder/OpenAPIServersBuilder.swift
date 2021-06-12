//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Builder for server information stored in `servers` part of OpenAPI.
class OpenAPIServersBuilder {

    let servers: [APIServer]

    init(servers: [APIServer]) {
        self.servers = servers
    }

    func built() -> [OpenAPIServer] {
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
