//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import Swiftgger

class Program {
    func run() -> Bool {
        let openAPIBuilder = OpenAPIBuilder(
            title: "Swiftgger OpenAPI document",
            version: "1.0.0",
            description: "OpenAPI documentation for test structure purposes",
            authorizations: [
                .basic(description: "Basic authorization"),
                .apiKey(description: "Api key authorization"),
                .jwt(description: "JWT authorization"),
                .oauth2(description: "OAuth authorization", flows: [
                    .implicit(APIAuthorizationFlow(authorizationUrl: "https://oauth2.com", tokenUrl: "https://oauth2.com/token", scopes: [:]))
                ]),
                .openId(description: "OpenIdConnect authorization", openIdConnectUrl: "https//opeind.com")
            ]
        )
        .add([
            APIObject(object: Vehicle(name: "Ford",
                                      age: 21,
                                      fuels: [
                                        Fuel(level: 91, type: "E98", productionDate: Date(), parameters: ["power", "speed"]),
                                        Fuel(level: 90, type: "GAS", productionDate: Date(), parameters: ["power", "speed"])
                                      ],
                                      currentFuel: nil,
                                      hasEngine: false,
                                      tags: ["key": "value"],
                                      dictionary: [
                                        "somethinf" : Fuel(level: 1, type: "GAS", productionDate: Date(), parameters: ["power", "speed"])
                                      ],
                                      keyId: UUID(),
                                      uuidIds: [UUID(), UUID(), UUID()])),
            APIObject(object: Fuel(level: 90, type: "GAS", productionDate: Date(), parameters: ["power", "speed"])),
            APIObject(object: Species(name: "Ant", countryOfOrigin: "Africa"))
        ])
        .add(APIController(name: "VehiclesController", description: "Contoller for vehicles", actions: [
            APIAction(method: .get,
                      route: "/version/ownername",
                      summary: "Get vehicle owner name",
                      description: "GET action for downloading vehicle owner name.",
                      responses: [
                        APIResponse(code: "200", description: "Vehicle owner name", type: .value("John doe"), contentType: "application/text"),
                        APIResponse(code: "401", description: "Unauthorized")
                      ]
            ),
            APIAction(method: .get,
                      route: "/version/certificates",
                      summary: "Get vehicle certificates",
                      description: "GET action for downloading vehicle certificates.",
                      responses: [
                        APIResponse(code: "200", description: "Vehicle certificates", type: .value(["EURO 6", "ABS"]), contentType: "application/json"),
                        APIResponse(code: "401", description: "Unauthorized")
                      ]
            ),
            APIAction(method: .get,
                      route: "/vehicles",
                      summary: "Get list of vehicles",
                      description: "GET action for downloading list of vehicles.",
                      responses: [
                        APIResponse(code: "200", description: "List of vehicles", type: .object(Vehicle.self, asCollection: true), contentType: "application/json"),
                        APIResponse(code: "401", description: "Unauthorized")
                      ]
            ),
            APIAction(method: .get,
                      route: "/vehicles/{id}",
                      summary: "Get single vehicle",
                      description: "GET action for downloading specific vehicle.",
                      parameters: [
                        APIParameter(name: "id", description: "Vehicle id", required: true)
                      ],
                      responses: [
                        APIResponse(code: "200", description: "List of vehicles", type: .object(Vehicle.self), contentType: "application/json"),
                        APIResponse(code: "401", description: "Unauthorized"),
                        APIResponse(code: "403", description: "Forbidden"),
                        APIResponse(code: "404", description: "NotFound")
                      ]
            ),
            APIAction(method: .post,
                      route: "/vehicles",
                      summary: "Create new vehicle",
                      description: "POST action for creating new vehicle.",
                      request: APIRequest(type: .object(Vehicle.self), description: "New vehicle", contentType: "application/json"),
                      responses: [
                        APIResponse(code: "201", description: "Created vehicles", type: .object(Vehicle.self), contentType: "application/json"),
                        APIResponse(code: "401", description: "Unauthorized"),
                        APIResponse(code: "403", description: "Forbidden")
                      ]
            ),
            APIAction(method: .put,
                      route: "/vehicles/{id}",
                      summary: "Update vehicle",
                      description: "PUT action for updating existing vehicle.",
                      parameters: [
                        APIParameter(name: "id", description: "Vehicle id", required: true)
                      ],
                      request: APIRequest(type: .object(Vehicle.self), description: "New vehicle", contentType: "application/json"),
                      responses: [
                        APIResponse(code: "200", description: "Updated vehicles", type: .object(Vehicle.self), contentType: "application/json"),
                        APIResponse(code: "401", description: "Unauthorized"),
                        APIResponse(code: "403", description: "Forbidden"),
                        APIResponse(code: "404", description: "NotFound")
                      ]
            ),
            APIAction(method: .delete,
                      route: "/vehicles/{id}",
                      summary: "Delete vehicle",
                      description: "DELETE action for deleting specific vehicle.",
                      parameters: [
                        APIParameter(name: "id", description: "Vehicle id", required: true)
                      ],
                      responses: [
                        APIResponse(code: "200", description: "Success"),
                        APIResponse(code: "401", description: "Unauthorized"),
                        APIResponse(code: "403", description: "Forbidden"),
                        APIResponse(code: "404", description: "NotFound")
                      ],
                      authorization: true
            ),
            APIAction(method: .get,
                      route: "/vehicles/tags",
                      summary: "Get vehicle associated tags",
                      description: "GET action for downloading vehicle associated tags.",
                      responses: [
                        APIResponse(code: "200", description: "Vehicle tags", type: .dictionary(String.self)),
                        APIResponse(code: "401", description: "Unauthorized")
                      ]
            ),
            APIAction(method: .get,
                      route: "/vehicles/fuels",
                      summary: "Get vehicle associated fuels",
                      description: "GET action for downloading vehicle associated fuels.",
                      responses: [
                        APIResponse(code: "200", description: "Vehicle fuels", type: .dictionary(Fuel.self)),
                        APIResponse(code: "401", description: "Unauthorized")
                      ]
            ),
            APIAction(method: .get,
                      route: "/echo",
                      summary: "Send text",
                      description: "GET action for printing request in response body",
                      request: APIRequest(type: .value("Hello world!"), description: "Echo text", contentType: "application/text"),
                      responses: [
                        APIResponse(code: "200", description: "List of vehicles", type: .value("(Response) Hello world!"), contentType: "application/text")
                      ]
            )
        ]))

        let openAPIDocument = openAPIBuilder.built()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try! encoder.encode(openAPIDocument)
        let jsonOptionalString = String(bytes: jsonData, encoding: .utf8)

        guard let jsonString = jsonOptionalString else {
            print("Error during converting object into string")
            return false
        }
        
        print(jsonString)
        return true
    }
}
